const jwt = require("jsonwebtoken");
const models = require("../models");
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");

const signUp = errorHandler(withTransaction(async (req, res, session)=> {
    const userDoc = models.User({ 
        email: req.body.email,
        password: await argon2.hash(req.body.password)
    });
    const refreshTokenDoc = models.RefreshToken({ 
        owner: userDoc.id
    });
    await userDoc.save({session});
    await refreshTokenDoc.save({session});
    const refreshToken = createRefreshToken(userDoc.id, refreshTokenDoc.id);
    const accessToken = createAccessToken(userDoc.id);
    return{ 
        id: userDoc.id,
        accessToken,
        refreshToken
    };
}));

function createAccessToken(userId) {
    return jwt.sign({ 
        userId: userId
    }, process.env.ACCESS_TOKEN_SECRET, { 
        expiresIn: '10m'
    });
}

function createRefreshToken(userId, refreshTokenId) {
    return jwt.sign({ 
        userId: userId,
        tokenId: refreshTokenId
    }, process.env.REFRESH_TOKEN_SECRET, {
        expiresIn: '30d'
    });
}