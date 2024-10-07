const jwt = require("jsonwebtoken");
const models = require("../models");
const {errorHandler, withTransaction} = require("../util");
const {HttpError} = require("../error");
const argon2 = require("argon2");

const signUp = errorHandler(withTransaction(async (req, res, session)=> {
    const userDoc = models.User({ 
        email: req.body.email,
        password: await argon2.hash(req.body.password),
        level: -1
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
        level: userDoc.level
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
    return {
        id: userDoc.id,
        accessToken,
        refreshToken,
        level: userDoc.level
    };
}));

const logout = errorHandler(withTransaction(async (req, res, session) => {
    const refreshToken = await validateRefreshToken(req.body.refreshToken);
    await models.RefreshToken.deleteOne({_id: refreshToken.tokenId}, {session});
    return {success: true};
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

const verifyPassword = async (hashedpw, rawpw) => { 
    if(await argon2.verify(hashedpw, rawpw)) {

    } else {
        throw new HttpError(401, 'Wrong username or password');
    }
};

module.exports = {
    signUp,
    login,
    logout,
    newAccessToken,
    newRefreshToken
}
