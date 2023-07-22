import 'package:flutter/material.dart';
import 'package:typebleh/utils/socket_methods.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gameIDController = TextEditingController();

  final SocketAPI _socketAPI = SocketAPI();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketAPI.updateGameListener(context);
    _socketAPI.notCorrectGameListener(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    gameIDController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Join Room',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomTextField(
                      controller: nameController, hintText: "Username"),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  CustomTextField(
                      controller: gameIDController, hintText: "Game ID"),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  CustomButton(
                      text: "Join",
                      onTap: () {
                        // print("HEELLLO");
                        _socketAPI.joinGame(
                            nameController.text, gameIDController.text);
                      })
                ],
              )),
        ),
      ),
    );
  }
}
