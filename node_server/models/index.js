const User = require("./registration");
const Question = require("./questions");
const RefreshToken = require("./refreshTokenModel");
const Image = require('./image');
const AccessToken = require("./accessTokenModel")

module.exports = { 
    User,
    Question,
    RefreshToken,
    AccessToken,
    Image,
}