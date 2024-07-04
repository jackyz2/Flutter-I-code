const mongoose = require("mongoose");

let accessTokenSchema = new mongoose.Schema({ 
    owner: { 
        type: mongoose.Schema.Types.ObjectId, ref: 'User'
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: '10m' 
    },
    tokenType: {
        type: String,
        default:"accessToken"
    }
})

const accessToken = mongoose.model("AccessToken", accessTokenSchema);
module.exports = accessToken