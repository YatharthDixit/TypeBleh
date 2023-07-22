import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';
import 'package:typebleh/utils/socket_client.dart';
import 'package:typebleh/widgets/custom_button.dart';

import '../utils/socket_methods.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({super.key});

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}
class _GameTextFieldState extends State<GameTextField> {
  TextEditingController gameController = TextEditingController();

  handleTextChange(String value, String gameID) {
    var lastChar = value.length < 1 ? 0 : value[value.length - 1];
    if (lastChar == ' ') {
      _socketAPI.sendUserInput(value, gameID);
      setState(() {
        gameController.text = '';
      });
    }
  }

  bool isButton = true;

  final SocketAPI _socketAPI = SocketAPI();
  late GameStateProvider? game;
  var playerMe = null;

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayer(game!);
  }

  findPlayer(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  handleStart(GameStateProvider game) {
    _socketAPI.startTimer(playerMe, game.gameState['id']);
    setState(() {
      isButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);

    return playerMe['isGameLeader'] && isButton
        ? CustomButton(
            text: "START",
            onTap: () => handleStart(gameData),
          )
        : TextFormField(
            readOnly: gameData.gameState['isJoin'],
            controller: gameController,
            onChanged: (value) {
              handleTextChange(value, gameData.gameState['id']);
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                fillColor: const Color(0xffF5F5FA),
                hintText: "Type Here!",
                hintStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          );
  }
}
