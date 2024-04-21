const mongoose = require("mongoose");

let QuestionSchema = new mongoose.Schema({ 
    questionTitle: String,
    options: Array,
    imageUrl: String,
    category: String,
});

const Question = mongoose.model("Question", QuestionSchema);
module.exports = Question