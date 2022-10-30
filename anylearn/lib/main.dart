import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/views/home.dart';
import 'package:anylearn/views/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.refreshAuth();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'Home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
    redirect: (context, state) async {
      final bool isLoggingIn = state.subloc == state.namedLocation("Login");

      if (await AuthService.checkAuth()) {
        return null;
      } else {
        return isLoggingIn ? null : state.namedLocation('Login');
      }
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AnyLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
