const express = require('express');
const router = express.Router();
const { errorHandler, withTransaction } = require("../util");
const { HttpError } = require("../error");
const models = require("../models");


const getImageById = errorHandler(withTransaction(async (req, res, session) => {

    let imageDoc = await models.Image.findById(req.params.id).session(session);
    if (!imageDoc) {
        throw new HttpError(404, 'Image not found');
    }

    res.contentType('image/jpeg'); 
    res.send(imageDoc.image);
}));


router.get('/image/:id', getImageById);

module.exports = router;

