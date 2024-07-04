
const jwt = require("jsonwebtoken");
const {HttpError} = require("../error");
const models = require("../models");
const {createAccessToken} = require("./auth.controller")

const verifyTokenAndFetchUser = async (accessToken, refreshToken) => {
    try {
      const decodeToken = (token) => jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
  
      const { payload, expired } = (() => {
        try {
          const payload = decodeToken(accessToken);
          return { payload, expired: false };
        } catch (err) {
          if (err.name === 'TokenExpiredError') {
            return { payload: decodeToken(accessToken, { ignoreExpiration: true }), expired: true };
          }
          throw new HttpError(401, 'Unauthorized');
        }
      })();
  
      if (payload && !expired) {
        return { user: await models.User.findById(payload.userId) }
      }
  
      if (expired && refreshToken) {
        const accessTokenDoc = models.RefreshToken({
            owner: currentRefreshToken.userId,
            tokenType: "accessToken"
        });
    
        await accessTokenDoc.save({session});
        await models.AccessToken.deleteOne({_id: refreshToken.tokenId}, {session});
        const accessToken = createAccessToken(refreshToken.userId, accessTokenDoc.id);
  
  
        return {
          user: await models.User.findById(session.userId),
          accessToken,
        };
      }
  
      throw new HttpError(401, 'Unauthorized');
    } catch (err) {
      throw new HttpError(401, 'Unauthorized');
    }
  };

  module.exports = { verifyTokenAndFetchUser };