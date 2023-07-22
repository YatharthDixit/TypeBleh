import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: game.gameState['players'].length,
        itemBuilder: (context, index) {
          var playerData = game.gameState['players'][index];
          return ListTile(
            title: Text(
              playerData['username'],
              style: TextStyle(fontSize: 20),
            ),
            trailing: Text(
              playerData['WPM'].toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
