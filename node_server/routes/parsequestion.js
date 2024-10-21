const express = require('express')
const router = express.Router()
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");
const models = require("../models");

const jwt = require("jsonwebtoken");
  
const parseQ = errorHandler(withTransaction(async(req, res, session) => {
  const decodeToken = (token) => {
    try {
        return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
    } catch(err) {
          // err
        throw new HttpError(401, 'Unauthorised');
    }
  }

    const refreshToken = decodeToken(req.body.refreshToken);
    let user = await models.User.findById(refreshToken.userId);
    console.log("User:", user);
    const userLevel = user.level + 1;
    console.log("UserLevel:", userLevel);
    let questions = await models.Question.aggregate([ 
      {$match: {category: userLevel.toString()}},
      {$sample: {size: 5}}
    ]);

    console.log("Question:", questions);

    const parsedQuestions = questions.map(q => ({ 
      questionTitle: q.questionTitle,
      options: q.options,
      imageUrl: q.imageUrl,
      category: q.category,
      answer: q.answer,
      isTree: q.isTree
    }));
    return res.json(parsedQuestions);
}));

const updateLevel = errorHandler(withTransaction(async(req, res, session) => { 
  const decodeToken = (token) => { 
    try { 
      return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
    } catch(err) {
      throw new HttpError(401, 'Unauthorised');
    }
  }

  const refreshToken = decodeToken(req.body.refreshToken);
  const newLevel = req.body.level;
  console.log(newLevel);
  //const InewLevel = parseInt(newLevel);
  let user = await models.User.findById(refreshToken.userId);
 
  user.level = newLevel;
  await user.save({session});
}))

const parseUser = errorHandler(withTransaction(async(req, res, session) => {
  const decodeToken = (token) => {
    try {
        return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
    } catch(err) {
        // err
        throw new HttpError(401, 'Unauthorised');
    }
  }

  const refreshToken = decodeToken(req.body.refreshToken);
  let user = await models.User.findById(refreshToken.userId);
  console.log("User:", user);
  const userLevel = user.level + 1;//this is not changing the level, this is simply returning the level, and because level starts from -1, we have to +1
  console.log("UserLevel:", userLevel);
  const interests = user.interests;
  const randomInterest = interests[Math.floor(Math.random() * interests.length)];
  console.log("Random Interest:", randomInterest);

  return res.json({
    userLevel: userLevel,
    interest: randomInterest
  });
}));

const updateUserInterest = errorHandler(withTransaction(async (req, res, session) => {
  // Function to decode the JWT token
  const decodeToken = (token) => {
    try {
      return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
    } catch (err) {
      throw new HttpError(401, 'Unauthorized');
    }
  };

  // Decode the token to get the userId
  const refreshToken = decodeToken(req.body.refreshToken);
  
  // Find the user by their ID
  let user = await models.User.findById(refreshToken.userId).session(session);
  
  // Check if the user exists
  if (!user) {
    throw new HttpError(404, 'User not found');
  }

  // Get the new interest from the request body
  const newInterest = req.body.newInterest;
  console.log("New Interest:", newInterest);

  if(!user.interests) {
    user.interests = []; //if the existing user does not have a interests attribute
  }

  // Check if the interest already exists to avoid duplicates
  if (user.interests.includes(newInterest)) {
    return res.status(400).json({ message: "Interest already exists." });
  }

  // Use $addToSet to prevent duplicates being added to the interests array
  await models.User.updateOne(
    { _id: user._id },
    { $addToSet: { interests: newInterest } },
    { session }
  );

  // Respond with a success message or the updated user
  res.json({ message: "Interest added successfully", user: user });

}));



router.post('/updatelevel', updateLevel);
router.post('/parseq', parseQ);
router.post('/parseuser', parseUser);
router.post('/updateinterest', updateUserInterest);
module.exports = router;