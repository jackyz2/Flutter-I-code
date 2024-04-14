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
    }
})

const User = mongoose.model("User", UserSchema);
module.exports = User