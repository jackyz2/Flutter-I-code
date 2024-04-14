const express = require('express')
const router = express.Router()

const authcontroller = require('../controllers/authcontroller')

router.post('/signup', function(req, res) {
    authcontroller.signup
})

module.exports = router