const express = require('express')
const router = express.Router()
const authRouter = require('./auth');
const parseqRouter = require('./parsequestion');
router.use('/auth', authRouter);
router.use('/parse', parseqRouter);
module.exports = router;