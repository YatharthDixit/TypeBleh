import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/client_state_provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';
import 'package:typebleh/utils/socket_methods.dart';
import 'package:typebleh/widgets/game_text_field.dart';

import '../widgets/sentence_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketAPI _socketAPI = SocketAPI();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketAPI.updateTimer(context);
    _socketAPI.updateGame(context);
    _socketAPI.gameFinishedListener();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(children: [
            Text(clientStateProvider.clientState['timer']['msg'].toString(),
                style: const TextStyle(
                  fontSize: 18,
                )),

            SizedBox(
              height: 10,
            ),

            Chip(
              label: Text(
                clientStateProvider.clientState['timer']['countDown']
                    .toString(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            game.gameState['isJoin'] 
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: game.gameState['id']))
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Game code copied successfully.')));
                        });
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          fillColor: const Color(0xffF5F5FA),
                          hintText: "Click to copy Game code",
                          hintStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  )
                : Column(
                    children: [
                      
                      SentenceGame(),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: game.gameState['players'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(game.gameState['players'][index]
                                        ['username']),
                                  ),
                                  Slider(
                                    value: (game.gameState['players'][index]
                                            ['currentWordIndex'] /
                                        game.gameState['words'].length),
                                    onChanged: (value) {},
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            // Text(game.gameState['id']),
          ]),
        ),
      )),
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: GameTextField()),
    );
  }
}
