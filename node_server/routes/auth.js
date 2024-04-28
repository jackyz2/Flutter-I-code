const express = require('express')
const router = express.Router()
const controllers = require('../controllers');

router.post('/signup', controllers.signUp)
router.post('/login', controllers.login);
router.post('/newactoken', controllers.newAccessToken);
router.post('/newrftoken', controllers.newRefreshToken);
router.post('/logout', controllers.logout);
module.exports = router;
