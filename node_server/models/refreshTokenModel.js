const mongoose = require("mongoose");

let refreshTokenSchema = new mongoose.Schema({ 
    owner: { 
        type: mongoose.Schema.Types.ObjectId, ref: 'User'
    }
})

const RefreshToken = mongoose.model("RefreshToken", refreshTokenSchema);
module.exports = RefreshToken