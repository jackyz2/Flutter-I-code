const { MongoClient } = require('mongodb');
const fs = require('fs');

const url = 'mongodb+srv://jackyz2:qiqi050621@i-code.9efpecs.mongodb.net/flutter?retryWrites=true&w=majority';
const dbName = 'flutter';

const imagePath = 'D:/Flutter-I-code/assets/images/cpp_bg.jpg';

const client = new MongoClient(url);

async function insertImage() {
    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection('images');

        const fileData = fs.readFileSync(imagePath);
        const base64Image = fileData.toString('base64');

        const result = await collection.insertOne({
            image: base64Image,
            description: 'An example image'
        });
        console.log('Image inserted with _id:', result.insertedId);
    } catch (err) {
        console.error(err);
    } finally {
        await client.close();
    }
}

insertImage();