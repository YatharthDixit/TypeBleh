const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const Game = require('./model/game');
const getSentence = require('./API/sentences');

const app = express();
const port = process.env.PORT || 3000;
const DB = 'mongodb+srv://yatharthdixit:yathdi1234@cluster0.lgyr5kh.mongodb.net/?retryWrites=true&w=majority';

mongoose.connect(DB).then(() => console.log("Database connection successful")).catch((e) => console.log(e));

var server = http.createServer(app);

const io = require('socket.io')(server);

io.on('connection', (socket) => {
    socket.on('create-game', async({username}) => {
        try{
            let game = new Game();
            const sentence = await getSentence();
            game.words = sentence;
            let player = {
                socketID : socket.id,
                username,
                isGameLeader: true,
            };
            game.players.push(player);
            game = await game.save();

            const gameID  = game._id.toString();
            socket.join(gameID);

            io.to(gameID).emit('updatedGame', game);

        }catch(e){
            console.log(e);
        }
    });
    socket.on('join-game', async({username, gameID}) => {
        try{
            if(!gameID.match(/^[0-9a-fA-F]{24}$/)){
                socket.emit('notCorrectGame', 'Please enter a valid Game ID');
                return;
            }
            let game = await Game.findById(gameID);
            if(game.isJoin){
                const id = game._id.toString();
                let player = {
                    username, 
                    socketID : socket.id,

                }
                socket.join(id); 
                game.players.push(player);
                game = await game.save();
                
                io.to(gameID).emit('updatedGame', game);
            }
            else{
                socket.emit('notCorrectGame', 'The game is in process, Please try after some time.')
            }


        }catch(e){
            console.log(e);
        }
    });

    socket.on('userInput', async ({userInput, gameID}) => {
        let game = await Game.findById(gameID);
        if(!game.isJoin && !game.isOver){
            let player = game.players.find(
                (p) => p.socketID === socket.id 
            );
            if(game.words[player.currentWordIndex] === userInput.trim()){
                player.currentWordIndex = player.currentWordIndex + 1;
                if(player.currentWordIndex !== game.words.length){
                    game = await game.save();
                    io.to(gameID).emit('updatedGame', game);
                }else{
                    let endTime = new Date().getTime();
                    let {startTime} = game ;
                    player.WPM = calculateWPM(endTime, startTime, player);
                    game = await game.save();
                    socket.emit('done');
                    io.to(gameID).emit('updatedGame', game);
                }

            }
        }
    })

    socket.on('timer', async({playerID, gameID}) => {
        let countDown = 5;
        let game = await Game.findById(gameID);
        let player = game.players.id(playerID);
        if(player.isGameLeader){
            let timerID = setInterval(async ()=>{
                if(countDown >= 0){

                    io.to(gameID).emit('timer', {
                        countDown,
                        msg : "Game Starting",
                    });
                    console.log(countDown);
                    countDown--;
                    
                }else{
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameID).emit('updatedGame', game);
                    startGameClock(gameID, socket);
                    clearInterval(timerID);
             }
            }, 1000);
        }
    });
});

const startGameClock = async (gameID, socket) => {
    let game = await Game.findById(gameID);
    game.startTime = new Date().getTime();
    game = await game.save();
    let time = 10;
    let timerID = setInterval(  () => {
        if(time>=0){ 
            const timeFormat = calculateTime(time);
            io.to(gameID).emit('timer', {
                countDown: timeFormat,
                msg : "Time Remaining"
            });
            console.log(timeFormat);
            time--;
        } else{

            try{ (async() => { let endTime = new Date().getTime();
            let game = await Game.findById(gameID);
            let {startTime} = game ;
            game.isOver = true; 
            game.players.forEach((player, index) =>{
                if(player.WPM == 0){
                    game.players[index].WPM = calculateWPM(endTime, startTime, player);
                }

            });
            game = await game.save();
            // socket.emit('done');
            io.to(gameID).emit('updatedGame', game);
            clearInterval(timerID);
        })();
        
        }catch(e){
            console.log(e);
        }
            // socket.emit('done');
            
        }
        
        
        
    },1000);
    
}

const calculateWPM = (endTime, startTime, player) =>  {
    const timeInSec = (endTime - startTime)/1000;
    const timeTaken = timeInSec/60;
    let wordsTyped = player.currentWordIndex;
    const WPM = Math.floor(wordsTyped / timeTaken);
    return WPM;

}

const calculateTime = (time) =>{
    let min = Math.floor(time/60);
    let sec = time % 60;

    return `${min}:${sec<10 ?"0" + sec: sec}`;
}


app.use(express.json());



server.listen(port, "0.0.0.0" , ()=>{
    console.log(`Server running on port : ${port}` );
});
