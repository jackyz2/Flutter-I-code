const { Int32 } = require("mongodb");
const mongoose = require("mongoose");

let QuestionSchema = new mongoose.Schema({ 
    questionTitle: String,
    options: Array,
    imageUrl: String,
    category: String,
    answer: String
});

const Question = mongoose.model("Question", QuestionSchema);
module.exports = Question