const express = require('express')
const router = express.Router()
const argon2 = require("argon2");
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");



function tmp(req, res) {}




const jwt = require("jsonwebtoken");
const models = require("../models");

const signUp = errorHandler(withTransaction(async (req, res, session)=> {
    const userDoc = models.User({ 
        email: req.body.email,
        password: await argon2.hash(req.body.password),
        level: 0
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
        refreshToken,
        level: user.level
    };
}));

const login = errorHandler(withTransaction(async(req, res, session) => {
    const userDoc = await models.User.findOne({email: req.body.email})
        .select('+password')
        .exec();
        if(!userDoc) {
            throw new HttpError(401, 'Wrong email');
        }
    await verifyPassword(userDoc.password, req.body.password);
    const refreshTokenDoc = models.RefreshToken({ 
        owner: userDoc.id
    });
    await refreshTokenDoc.save({session});
    const refreshToken = createRefreshToken(userDoc.id, refreshTokenDoc.id);
    const accessToken = createAccessToken(userDoc.id);
    //let user = await models.User.findById(refreshToken.id);
    //print(user.email);
    return {
        id: userDoc.id,
        accessToken,
        refreshToken,
        level: userDoc.level
    };
}));

const validateAccessToken = async (token) => {
    const decodeToken = () => {
        try {
            return jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        } catch(err) {
            // err
            throw new HttpError(401, 'Unauthorised');
        }
    }

    const decodedToken = decodeToken();
    const tokenExists = await models.RefreshToken.exists({_id: decodedToken.tokenId, owner: decodedToken.userId});
    if (tokenExists) {
        return decodedToken;
    } else {
        throw new HttpError(401, 'Unauthorised');
    }
};

const sessionAuth = errorHandler(withTransaction(async (req, res, session) => {
    // Decode the access token from the Authorization header
    const accessToken = req.headers.authorization?.split(' ')[1];  // Assuming token is sent as "Bearer <token>"

    if (!accessToken) {
        throw new HttpError(401, 'Access token is required');
    }

    // Validate the access token and retrieve the user ID encoded within
    let userId;
    try {
        const decoded = await validateAccessToken(accessToken);  // Function to verify token and extract user info
        userId = decoded.userId;
    } catch (error) {
        throw new HttpError(401, 'Invalid or expired access token');
    }

    // Fetch the user document using the ID from the access token
    const userDoc = await models.User.findById(userId).exec();
    if (!userDoc) {
        throw new HttpError(404, 'User not found');
    }

    // Process to handle refresh token creation or management
    if (req.body.operation === 'refreshAccessToken') {  // Assuming a field to specify the operation type
        const refreshToken = req.body.refreshToken;

        // Validate the provided refresh token
        if (!await validateRefreshToken(refreshToken)) {
            throw new HttpError(401, 'Invalid refresh token');
        }

        // Create a new access token
        const newAccessToken = createAccessToken(userDoc.id);
        const newRefreshToken = createRefreshToken(userDoc.id, refreshToken);  // Assuming refreshToken needs updating

        return {
            id: userDoc.id,
            accessToken: newAccessToken,
            refreshToken: newRefreshToken
        };
    }

    // If no specific operation, just return user info
    return { id: userDoc.id };
}));


const verifyPassword = async (hashedpw, rawpw) => { 
    if(await argon2.verify(hashedpw, rawpw)) {

    } else {
        throw new HttpError(401, 'Wrong username or password');
    }
};

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

const newRefreshToken = errorHandler(withTransaction(async (req, res, session) => {
    const currentRefreshToken = await validateRefreshToken(req.body.refreshToken);
    const refreshTokenDoc = models.RefreshToken({
        owner: currentRefreshToken.userId
    });

    await refreshTokenDoc.save({session});
    await models.RefreshToken.deleteOne({_id: currentRefreshToken.tokenId}, {session});

    const refreshToken = createRefreshToken(currentRefreshToken.userId, refreshTokenDoc.id);
    const accessToken = createAccessToken(currentRefreshToken.userId);

    return {
        id: currentRefreshToken.userId,
        accessToken: accessToken,
        refreshToken: refreshToken,
        //level: user.level
    };
}));

const newAccessToken = errorHandler(async (req, res) => {
    const refreshToken = await validateRefreshToken(req.body.refreshToken);
    const accessToken = createAccessToken(refreshToken.userId);
    let user = await models.User.findById(refreshToken.userId);
    //print(user.email);
    
    return {
        id: refreshToken.userId,
        accessToken: accessToken,
        refreshToken: req.body.refreshToken,
        level: user.level
    };
});

const logout = errorHandler(withTransaction(async (req, res, session) => {
    const refreshToken = await validateRefreshToken(req.body.refreshToken);
    await models.RefreshToken.deleteOne({_id: refreshToken.tokenId}, {session});
    return {success: true};
}));


const validateRefreshToken = async (token) => {
    const decodeToken = () => {
        try {
            return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
        } catch(err) {
            // err
            throw new HttpError(401, 'Unauthorised');
        }
    }

    const decodedToken = decodeToken();
    const tokenExists = await models.RefreshToken.exists({_id: decodedToken.tokenId, owner: decodedToken.userId});
    if (tokenExists) {
        return decodedToken;
    } else {
        throw new HttpError(401, 'Unauthorised');
    }
};






router.post('/signup', signUp)
router.post('/login', login);
router.post('/sessionauth', sessionAuth);
router.post('/newactoken', newAccessToken);
router.post('/newrftoken', newRefreshToken);
router.post('/logout', logout);
module.exports = router;