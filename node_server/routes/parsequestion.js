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
    const userLevel = user.level;
    console.log("UserLevel:", userLevel);
    let questions = await models.Question.aggregate([ 
      {$match: {category: userLevel.toString()}},
      {$sample: {size: 2}}
    ]);

    console.log("Question:", questions);

    const parsedQuestions = questions.map(q => ({ 
      questionTitle: q.questionTitle,
      options: q.options,
      imageUrl: q.imageUrl,
      category: q.category,
      answer: q.answer
    }));
    return res.json(parsedQuestions);
}));

router.post('/parseq', parseQ)
module.exports = router;