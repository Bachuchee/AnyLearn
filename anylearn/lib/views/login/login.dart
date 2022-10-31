import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/login/components.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/logo.png'),
          width: 250.0,
          height: 250.0,
        ),
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: const [
          Expanded(
            flex: 1,
            child: LoginSection(),
          ),
          Expanded(
            flex: 2,
            child: Image(
              image: AssetImage('assets/images/login_splash.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
