const axios = require('axios'); 

const getSentence = async() =>{
    const sentenceData = await axios.get('https://api.quotable.io/random');
    return sentenceData.data.content.split(" ");
};

module.exports = getSentence