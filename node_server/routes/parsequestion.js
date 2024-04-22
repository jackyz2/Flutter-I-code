const express = require('express')
const router = express.Router()
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");
const models = require("../models");


app.get('/questions', async (req, res) => {
    try {
      const questions = await Question.find({});
      res.status(200).send(questions);
    } catch (error) {
      res.status(500).send(error);
    }
  });

  
  const parseQ = errorHandler(withTransaction(async(req, res, session) => {
    const refreshToken = req.body.refreshToken;
    let user = await models.User.findById(refreshToken.userId);
    
    return {
        id: userDoc.id,
        accessToken,
        refreshToken,
        level: userDoc.level
    };
}));