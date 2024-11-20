require('dotenv').config({path: '../.env'})
const { MongoClient } = require('mongodb');
const fs = require('fs');

const url = process.env.DATABASE_URL;
const dbName = 'flutter';

const imagePath = 'D:/Flutter-I-code/assets/images/cpp_bg.jpg';

const client = new MongoClient(url, { useNewUrlParser: true });

async function insertImage() {
    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection('images');

        const fileData = fs.readFileSync(imagePath);


        const result = await collection.insertOne({
            image: fileData,
            description: 'Binary example'
        });
        console.log('Image inserted with _id:', result.insertedId);
    } catch (err) {
        console.error(err);
    } finally {
        await client.close();
    }
}

insertImage();
