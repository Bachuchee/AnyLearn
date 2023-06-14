import 'package:anylearn/views/login/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final _url = Uri.parse('https://20miny5dn5n.typeform.com/to/PN8rhWVa');

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
              onPressed: () async {
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
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
