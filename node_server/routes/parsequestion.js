const express = require('express')
const router = express.Router()
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");
const models = require("../models");
const {verifyTokenAndFetchUser} = require("../controllers/verifyAccessToken")
//const jwt = require("jsonwebtoken");
  
  const parseQ = errorHandler(withTransaction(async(req, res, session) => {

    const { accessToken, refreshToken } = req.body;

    const result = await verifyTokenAndFetchUser(accessToken, refreshToken);
    let user = result.user;
    const newAccessToken = result.accessToken;
  

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
    return res.json({
      parsedQuestions,
      newAccessToken: newAccessToken || null,
    });
}));

router.post('/parseq', parseQ)
module.exports = router;