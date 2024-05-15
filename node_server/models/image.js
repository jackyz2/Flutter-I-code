const mongoose = require("mongoose");

const ImageSchema = new mongoose.Schema({
    image: {
        type: Buffer,
        required: true
    },
    description: {
        type: String,
        required: false
    }
});

const Image = mongoose.model('Image', ImageSchema);

module.exports = Image;