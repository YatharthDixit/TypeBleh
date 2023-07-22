const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    username : {
        type : String,

    },
    currentWordIndex : {
        type : Number,
        default : 0,


    },
    WPM : {
        type : Number,
        default : 0,

    },
    socketID : {
        type : String,
    },
    isGameLeader : {
        type : Boolean,
        default : false,
    }
});

module.exports = playerSchema;