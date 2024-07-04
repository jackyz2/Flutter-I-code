const mongoose = require("mongoose");

let refreshTokenSchema = new mongoose.Schema({ 
    owner: { 
        type: mongoose.Schema.Types.ObjectId, ref: 'User'
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: '30d' 
    },
    tokenType: {
        type: String,
        default:"refreshToken"
    }
})

const RefreshToken = mongoose.model("RefreshToken", refreshTokenSchema);
module.exports = RefreshToken