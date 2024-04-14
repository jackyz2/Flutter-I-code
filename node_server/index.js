const express = require("express");
const mongoose = require('mongoose')
const app = express();
const Questions = require("./question");

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

    app.post("/api/add_data", async (req, res)=> {
        console.log("Result", req.body);
        let data = Questions(req.body);
        try {
            let dataToStore = await data.save();
            res.status(200).json(dataToStore);
        } catch (error) {
            res.status(400).json({ 
                'status': error.message
            })        }
    })




app.listen(2000, ()=>{
    console.log("Connected to server at 2000");
});