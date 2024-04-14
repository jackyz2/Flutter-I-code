const express = require("express");
const mongoose = require('mongoose')
const app = express();
const jwt = require('jsonwebtoken');
const authRoute = require('./routes/index')


app.use(express.json());

app.use(express.urlencoded({ 
    extended: true
}));



const uri = "mongodb+srv://jackyz2:qiqi050621@i-code.9efpecs.mongodb.net/flutter";


async function connect() {
    try {
        await mongoose.connect(uri)
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error(error);
    }
}
connect();

app.use('/api', authRoute)





app.listen(2000, ()=>{
    console.log("Connected to server at 2000");
});