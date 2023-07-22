import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typebleh/provider/client_state_provider.dart';
import 'package:typebleh/provider/game_state_provider.dart';
import 'package:typebleh/screens/create_screen.dart';
import 'package:typebleh/screens/game_screen.dart';
import 'package:typebleh/screens/home_screen.dart';
import 'package:typebleh/screens/join_room.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientStateProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Type Bleh',
        theme: ThemeData(
          primaryColor: Colors.teal.shade900,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/create-room': (context) => CreateRoomScreen(),
          '/join-room': (context) => JoinRoomScreen(),
          '/game-screen': (context) => GameScreen(),
        },
      ),
    );
  }
}
