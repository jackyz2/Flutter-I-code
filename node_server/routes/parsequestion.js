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
  const userLevel = user.level + 1;
  console.log("UserLevel:", userLevel);
  const interests = user.interests;
  const randomInterest = interests[Math.floor(Math.random() * interests.length)];
  console.log("Random Interest:", randomInterest);

  return res.json({
    userLevel: userLevel,
    interest: randomInterest
  });
}));


router.post('/updatelevel', updateLevel);
router.post('/parseq', parseQ);
router.post('/parseuser', parseUser);
module.exports = router;