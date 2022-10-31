import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/login/components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  final _client = PocketClient.getClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: LoginSection(),
      ),
    );
  }
}
