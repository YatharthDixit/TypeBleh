import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';
import 'package:typebleh/utils/socket_methods.dart';
import 'package:typebleh/widgets/scoreBoard.dart';

import '../utils/socket_client.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  final SocketAPI _socketAPI = SocketAPI();
  var playerMe = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketAPI.updateGame(context);
  }

  Widget getTypedWords(words, player) {
    var tempWords = words.sublist(0, player['currentWordIndex']);
    String typedWord = tempWords.join(" ");
    return Text(
      typedWord,
      style: const TextStyle(
        fontSize: 30,
        color: Color.fromRGBO(52, 235, 119, 1),
      ),
    );
  }

  Widget getWordsToType(words, player) {
    var tempWords = words.sublist(player['currentWordIndex'] + 1, words.length);
    String wordsToBeTyped = tempWords.join(" ");
    return Text(
      wordsToBeTyped,
      style: const TextStyle(
        fontSize: 30,
        color: Color.fromRGBO(52, 235, 119, 1),
      ),
    );
  }

  Widget getCurrentWords(words, player) {
    return Text(
      words[player['currentWordIndex']],
      style:
          const TextStyle(fontSize: 30, decoration: TextDecoration.underline),
    );
  }

  findPlayer(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayer(game);
    return 
    game.gameState['words'].length > playerMe['currentWordIndex'] &&
            !game.gameState['isOver']
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              
              textDirection: TextDirection.ltr,
              children: [
                // getTypedWords(game.gameState['words'], playerMe),
                getCurrentWords(game.gameState['words'], playerMe),
                getWordsToType(game.gameState['words'], playerMe),
              ],
            ),
          )
        : Container(
            child: Center(
              child: ScoreBoard(),
            ),
          );
  }
}
