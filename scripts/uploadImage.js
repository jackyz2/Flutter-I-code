const { MongoClient } = require('mongodb');
const fs = require('fs');

const url = 'mongodb+srv://jackyz2:qiqi050621@i-code.9efpecs.mongodb.net/flutter?retryWrites=true&w=majority';
const dbName = 'flutter';

const imagePath = '/Users/jackyzhang/development/i-code/assets/images/tree1.jpg';

const client = new MongoClient(url);

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
