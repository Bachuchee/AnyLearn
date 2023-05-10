// ignore_for_file: use_build_context_synchronously

import 'package:animate_gradient/animate_gradient.dart';
import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  final _client = PocketClient.client;

  Future<void> _signIn() async {
    try {
      final userData = await _client
          .collection('users')
          .authWithPassword(_emailController.text, _passwordController.text);

      await AuthService.saveAuth(userData.token);

      _emailController.clear();
      _passwordController.clear();

      context.go("/");
    } on ClientException catch (e) {
      final String message = e.response["message"];

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            secondaryColor,
            primaryColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80.0,
          ),
          const Text(
            "Where the world\ngoes to learn!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 60.0),
          Text(
            "Login:",
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 309.0,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: secondaryColor),
              cursorColor: secondaryColor,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Email",
                labelStyle: TextStyle(color: secondaryColor),
                focusColor: secondaryColor,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 309.0,
            child: TextField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(color: secondaryColor),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              cursorColor: secondaryColor,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Password",
                labelStyle: TextStyle(color: secondaryColor),
                focusColor: secondaryColor,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(18.0)),
                child: const Text(
                  "Login",
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                "dont have an account?",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 4.0),
              TextButton(
                onPressed: () {
                  context.go('/signup');
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ForgotPasswordDialog(),
              );
            },
            child: const Text("Forgot password?"),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _textController;
  bool _gotError = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<bool> sendForgotPassword() async {
    try {
      PocketClient.client
          .collection('users')
          .requestPasswordReset(_textController.text);
      return false;
    } catch (e) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Forgot Password",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "email",
                border: const OutlineInputBorder(),
                errorText:
                    _gotError ? "Account for that email doesn't exist" : null,
              ),
              onChanged: (text) => setState(() {
                _gotError = false;
              }),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: const Text("Submit"),
                onPressed: () async {
                  final res = await sendForgotPassword();
                  if (!res) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    _gotError = res;
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
