require('dotenv').config()
const express = require("express");
const mongoose = require('mongoose')
const app = express();
const jwt = require('jsonwebtoken');
const routes = require('./routes')


app.use(express.json());

app.use(express.urlencoded({ 
    extended: true
}));



const uri = process.env.DATABASE_URL;


async function connect() {
    try {
        await mongoose.connect(uri)
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error(error);
    }
}
connect();

app.use('/api', routes)





app.listen(2000, ()=>{
    console.log("Connected to server at 2000");
});