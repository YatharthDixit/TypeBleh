import 'package:flutter/material.dart';
import 'package:typebleh/widgets/custom_button.dart';
import 'package:typebleh/widgets/custom_text_field.dart';

import '../utils/socket_methods.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController nameController = TextEditingController();
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
                    'Create Room',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomTextField(
                      controller: nameController, hintText: "Username"),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  CustomButton(
                      text: "Create",
                      onTap: () {
                        _socketAPI.createGame(nameController.text);
                      })
                ],
              )),
        ),
      ),
    );
  }
}
