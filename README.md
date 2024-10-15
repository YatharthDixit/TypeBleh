
# TypeBleh - A Real-time Multiplayer Typing Game

This project implements a typing game application using Flutter for the frontend and Node.js for the backend. It allows users to test their typing speed either in solo mode or with friends in a multiplayer environment.

## Features

* **Solo Play:** Users can practice their typing skills individually.
* **Multiplayer with Friends:** Users can create rooms and invite friends to compete in real-time typing battles.
* **Scalability:** The application can handle multiple users in the same room.
* **Room Lock:** Once a game starts, no additional players can join, ensuring fair gameplay.
* **Real-time Communication:** Utilizes Socket.IO for instant updates and synchronized gameplay.

## Technologies Used

* **Frontend:** Flutter
* **Backend:** Node.js with ExpressJS
* **Database:** MongoDB
* **Real-time Communication:** Socket.IO
* **HTTP Requests:** Axios

## Setup Instructions

**Prerequisites:**

* Flutter SDK
* Node.js and npm
* MongoDB

**Frontend:**

1. Clone the repository: `git clone https://github.com/YatharthDixit/TypeBleh`
2. Navigate to the client directory: `cd typebleh/client`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

**Backend:**

1. Navigate to the server directory: `cd typebleh/server`
2. Install dependencies: `npm install`
3. Run the server: `npm start`

## Project Structure

* **client:** Contains the Flutter code for the frontend application.
* **server:** Contains the Node.js code for the backend server.

## API Endpoints

* **GET /API/sentences:** Fetches a random sentence for the typing test from an external API (`https://api.quotable.io/random`).

## Socket.IO Events

* **create-game:** Create a new game room.
* **join-game:** Join an existing game room.
* **updatedGame:** Receive updates on the game state.
* **notCorrectGame:** Notifies the client if trying to join an invalid game.
* **timer:** Start or update the game timer.
* **done:** Indicates that the game is finished.
* **userInput:** Send user input to the server.

## Data Models

* **Game:**
    * words: Array of words for the typing test.
    * players: Array of players in the game.
    * isJoin: Boolean indicating if the game is open to join.
    * isOver: Boolean indicating if the game is over.
    * startTime: Timestamp of when the game started.

* **Player:**
    * username: Player's username.
    * currentWordIndex: Player's current position in the typing test.
    * WPM: Player's words per minute score.
    * socketID: Player's Socket.IO socket ID.
    * isGameLeader: Boolean indicating if the player is the game leader.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

