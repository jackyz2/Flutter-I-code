const mongoose = require("mongoose");

let UserSchema = new mongoose.Schema({ 
    'email': {
        require: true,
        type: String,
        unique: true,
    },
    'password': {
        require: true,
        type: String,
        select: false,
    },
    'level': {
        type: Number,
        default: -1
    },
    'interests': {
        type: Array,
        default: []
    }
})

const User = mongoose.model("User", UserSchema);
module.exports = User