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
          width: 200.0,
          height: 200.0,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'AnyLearn',
                  applicationVersion: 'ver. 1.0',
                  applicationLegalese:
                      'Copyright @ Gal Aloni, ${DateTime.now().year}',
                  applicationIcon: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('assets/images/AnyLearnHat.png'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Contact Us!"),
                    content: const Text(
                      "You can cotact us by mail using this refrence email: support@anylearn.com (School Project no real email or contacting ;)",
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Ok"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Contact us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0x00000000),
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
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
