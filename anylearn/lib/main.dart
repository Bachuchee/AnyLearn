import 'package:anylearn/controllers/auth_service.dart';

import 'package:anylearn/utils/specialscroll.dart';
import 'package:anylearn/views/create_course/create_course.dart';
import 'package:anylearn/views/create_episode/create_episode.dart';
import 'package:anylearn/views/home/components/home_filter.dart';
import 'package:anylearn/views/home/home.dart';
import 'package:anylearn/views/login/login.dart';
import 'package:anylearn/views/ongoing_courses/ongoing_courses.dart';

import 'package:anylearn/views/shared/PageScaffold/page_scaffold.dart';
import 'package:anylearn/views/signup/signup.dart';
import 'package:anylearn/views/user_courses/user_courses.dart';
import 'package:anylearn/views/view_course/view_course.dart';
import 'package:anylearn/views/view_episode/view_episode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.refreshAuth();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'Home',
        builder: (context, state) => const PageScaffold(
          content: HomePage(),
          appbarExtension: HomeFilters(),
        ),
      ),
      GoRoute(
        path: '/user-courses',
        name: 'UserCourses',
        builder: (context, state) => const PageScaffold(
          content: UserCourses(),
        ),
      ),
      GoRoute(
        path: '/ongoing-courses',
        name: 'OngoingCourses',
        builder: (context, state) => const PageScaffold(
          content: OngoingCourses(),
          appbarExtension: HomeFilters(),
        ),
      ),
      GoRoute(
        path: '/new-course',
        name: 'NewCourse',
        builder: (context, state) => const CreateCourse(),
      ),
      GoRoute(
        path: '/new-episode',
        name: 'NewEpisode',
        builder: (context, state) => const CreateEpisode(),
      ),
      GoRoute(
        path: '/courses/:courseId',
        name: 'ViewCourse',
        builder: (context, state) =>
            ViewCourse(courseId: state.params['courseId']!),
      ),
      GoRoute(
        path: '/episodes/:episodeId',
        name: 'ViewEpisode',
        builder: (context, state) => ViewEpisode(
          episodeId: state.params['episodeId']!,
        ),
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
