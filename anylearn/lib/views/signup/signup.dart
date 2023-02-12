// ignore_for_file: use_build_context_synchronously

import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/controllers/file_service.dart';
import 'package:anylearn/models/pocket_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/topic.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final PageController _pageController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confrimController;
  late final TextEditingController _usernameController;
  List<Topic> _topicList = [];
  final List<String> _topics = [];
  final pocketClient = PocketClient.client;
  Uint8List _imageData = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confrimController = TextEditingController();
    _usernameController = TextEditingController();
    rootBundle.load('assets/images/DefaultAvatar.jpg').then(
          (value) => _imageData = value.buffer.asUint8List(
            value.offsetInBytes,
            value.lengthInBytes,
          ),
        );
    PocketClient.getTopics().then((value) {
      setState(() {
        _topicList = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confrimController.dispose();
    _usernameController.dispose();
  }

  Future<void> createAccount() async {
    try {
      await pocketClient.collection('users').create(
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
          'passwordConfirm': _confrimController.text
        },
      );

      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } on ClientException catch (e) {
      final message = e.response["errorMessage"];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  Future<void> signup() async {
    try {
      await pocketClient
          .collection('users')
          .authWithPassword(_emailController.text, _passwordController.text);
      if (await AuthService.updateProfile(
          _usernameController.text, "", _imageData, _topics)) {
        context.go("/");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't sign up"),
        ),
      );
    }
  }

  Future<void> setAvatar() async {
    final imageData = await FileService.getImage();
    if (imageData.isNotEmpty) {
      setState(() {
        _imageData = imageData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstPage = Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          createAccount();
        },
        backgroundColor: secondarySurface,
        foregroundColor: secondaryColor,
        icon: const Icon(Icons.arrow_forward),
        label: const Text("next"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: secondaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            const Text(
              "First Things First!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Please enter email and password:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 509.0,
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
              width: 509.0,
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
            SizedBox(
              width: 509.0,
              child: TextField(
                controller: _confrimController,
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(color: secondaryColor),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: secondaryColor,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: secondaryColor),
                  focusColor: secondaryColor,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    var secondPage = Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              if (_usernameController.text.length >= 4 &&
                  _usernameController.text.length <= 35) {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Username must be between 4 and 35 characters"),
                  ),
                );
              }
            },
            backgroundColor: secondarySurface,
            foregroundColor: secondaryColor,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("next"),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [secondaryColor, primaryColor]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            const Text(
              "Great!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Up next, how about creating your avatar?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 509.0,
              child: TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: secondaryColor),
                cursorColor: secondaryColor,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "username",
                  labelStyle: TextStyle(color: secondaryColor),
                  focusColor: secondaryColor,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Material(
              type: MaterialType.circle,
              color: primarySurface,
              child: InkWell(
                onTap: () => setAvatar(),
                child: CircleAvatar(
                  radius: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_imageData),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              "profile avatar",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );

    var thirdPage = Container(
      decoration: const BoxDecoration(color: primaryColor),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50.0),
          const Text(
            "Almost there!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "All that's left now is to pick some topics:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1.0,
                mainAxisExtent: 200.0,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _topicList.length,
              itemBuilder: (context, index) => InputChip(
                selected: _topics.contains(_topicList[index].id),
                onPressed: (_topics.length < 3 ||
                        _topics.contains(_topicList[index].id))
                    ? () {
                        if (_topics.contains(_topicList[index].id)) {
                          setState(() {
                            _topics.remove(_topicList[index].id);
                          });
                        } else {
                          setState(() {
                            _topics.add(_topicList[index].id);
                          });
                        }
                      }
                    : null,
                label: Text(_topicList[index].name),
                backgroundColor: primarySurface,
                selectedColor: selectedColor,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: (_topics.isNotEmpty && _topics.length <= 3)
                ? () => signup()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 36.0,
                vertical: 18.0,
              ),
            ),
            child: const Text("Signup"),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/Logo.png'),
          width: 200.0,
          height: 200.0,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            context.go('/login');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          firstPage,
          secondPage,
          thirdPage,
        ],
      ),
    );
  }
}
