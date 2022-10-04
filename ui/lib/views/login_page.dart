import 'package:chat/views/chat_view.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const inputColor = Color(0xFF1F2124);
    const textStyle = TextStyle(color: Colors.white, fontSize: 20);
    var textBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: inputColor));
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Chat App")), 
      body:
        Column(children:[
        Expanded(
        child: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
                child: SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: textStyle,
                        focusedBorder: textBorder,
                        border: textBorder,
                        enabledBorder: textBorder,
                        fillColor: inputColor,
                        filled: true,
                      ),
                      style: textStyle,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatView()))
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(inputColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              child: const Text("Login", style: textStyle),
                            )))
                  ]),
            ))))]));
  }
}
