const express = require('express')
const router = express.Router()
const authRouter = require('./auth');
const parseqRouter = require('./parsequestion');
const getImage = require('./image');
router.use('/auth', authRouter);
router.use('/parse', parseqRouter);
router.use('/image', getImage);
module.exports = router;