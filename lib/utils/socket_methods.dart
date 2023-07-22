import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/client_state_provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';
import 'package:typebleh/utils/socket_client.dart';

class SocketAPI {
  bool _isPlaying = false;
  final _socketClient = SocketClient.instance.socket!;

  //Create Game
  createGame(String username) {
    if (username.isNotEmpty) {
      _socketClient.emit('create-game', {'username': username});
    }
  }

  joinGame(String username, String gameID) {
    if (username.isNotEmpty && gameID.isNotEmpty) {
      _socketClient.emit('join-game', {'username': username, 'gameID': gameID});
    }
  }

  updateGameListener(BuildContext context) {
    _socketClient.on('updatedGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
                  id: data['_id'],
                  players: data['players'],
                  isJoin: data['isJoin'],
                  isOver: data['isOver'],
                  words: data['words']);

      if (data['_id'].isNotEmpty && !_isPlaying) {
        _isPlaying = true;
        Navigator.pushNamed(context, '/game-screen');
      }
    });
  }

  notCorrectGameListener(BuildContext context) {
    _socketClient.on(
        'notCorrectGame',
        (data) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data))));
  }

  startTimer(playerID, gameID) {
    _socketClient.emit('timer', {
      'playerID': playerID,
      'gameID': gameID,
    });
  }

  gameFinishedListener() {
    _socketClient.on('done', (data) => _socketClient.off('timer'));
  }

  sendUserInput(String value, String gameID) {
    _socketClient.emit('userInput', {
      'userInput': value,
      'gameID': gameID,
    });
  }

  updateTimer(BuildContext context) {
    final clientStateProvider =
        Provider.of<ClientStateProvider>(context, listen: false);
    _socketClient.on('timer', (data) {
      clientStateProvider.setClinetState(data);
    });
  }

  updateGame(BuildContext context) {
    _socketClient.on('updatedGame', (data) {
      // final gameStateProvider =
      Provider.of<GameStateProvider>(context, listen: false).updateGameState(
          id: data['_id'],
          players: data['players'],
          isJoin: data['isJoin'],
          isOver: data['isOver'],
          words: data['words']);
    });
  }
}
