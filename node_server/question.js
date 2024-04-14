const mongoose = require("mongoose")

let dataSchema = new mongoose.Schema( {
    'questionTitle': {
        require: true,
        type: String,
    }
});

module.exports = mongoose.model("node_js", dataSchema);