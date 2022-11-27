import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/views/home/components/specialscroll.dart';
import 'package:anylearn/views/home/home.dart';
import 'package:anylearn/views/login/login.dart';
import 'package:anylearn/views/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      GoRoute(
        path: '/signup',
        name: 'Signup',
        builder: (context, state) => const SignupPage(),
      )
    ],
    redirect: (context, state) async {
      final bool isLoggingIn =
          state.subloc == "/login" || state.subloc == '/signup';

      if (await AuthService.checkAuth()) {
        return null;
      } else {
        return isLoggingIn ? null : '/login';
      }
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AnyLearn',
      debugShowCheckedModeBanner: false,
      scrollBehavior: ChipListScroll(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
