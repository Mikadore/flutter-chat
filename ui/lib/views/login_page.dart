import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext ctx) {
    var textStyle = const TextStyle(color: Colors.white, fontSize: 20);
    return  Container(
        color: Theme.of(ctx).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: textStyle,
              ),
              style: textStyle,
            )
          ],)
        );
  }
}
