import 'package:flutter/material.dart';
import 'views/chat_view.dart';
import 'views/login_page.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var discordMaterial = const MaterialColor(0xFF2c2f33, {
      50: Color.fromRGBO(40, 47, 51, .1),
      100: Color.fromRGBO(40, 47, 51, .2),
      200: Color.fromRGBO(40, 47, 51, .3),
      300: Color.fromRGBO(40, 47, 51, .4),
      400: Color.fromRGBO(40, 47, 51, .5),
      500: Color.fromRGBO(40, 47, 51, .6),
      600: Color.fromRGBO(40, 47, 51, .7),
      700: Color.fromRGBO(40, 47, 51, .8),
      800: Color.fromRGBO(40, 47, 51, .9),
      900: Color.fromRGBO(40, 47, 51, 1),
    });
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: discordMaterial),
        home: const LoginPage() 
    );
  }
}
