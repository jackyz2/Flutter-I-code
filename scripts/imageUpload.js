// It's a testing file. Should be ignored

const mongoose = require('mongoose');
mongoose.set('debug', true);
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const File = require('D:/Flutter-I-code/node_server/models/images'); 

const connectDB = async () => {
  try {
    await mongoose.connect("mongodb+srv://jackyz2:qiqi050621@i-code.9efpecs.mongodb.net/flutter?retryWrites=true&w=majority", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 30000,
      socketTimeoutMS: 45000
    }, 30000);
    console.log('MongoDB connected');
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 1024 * 1024 * 5 }, // Limit file size to 5MB
}).single('file');

const uploadFile = (filePath) => {
  fs.readFile(filePath, (err, data) => {
    if (err) {
      console.error('Error reading file:', err);
      return;
    }

    const newFile = new File({
      img: {
        data: data,
        contentType: 'image/png' // Adjust the content type as needed
      }
    });

    newFile.save()
      .then(() => {
        console.log('File uploaded successfully');
        mongoose.disconnect();
      })
      .catch((error) => {
        console.error('Error uploading file:', error);
      });
  });
};

const main = async () => {
  await connectDB();

  const filePath = 'D:/Flutter-I-code/assets/images/test.jpg';
  uploadFile(filePath);
};

main();