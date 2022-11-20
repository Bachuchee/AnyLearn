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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/Logo.png'),
          width: 250.0,
          height: 250.0,
        ),
        backgroundColor: Colors.white,
      ),
      body: (() {
        if (MediaQuery.of(context).size.width > 1200.0) {
          return Row(
            children: [
              const Expanded(
                flex: 1,
                child: LoginSection(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_splash.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const LoginSection();
        }
      }()),
    );
  }
}
