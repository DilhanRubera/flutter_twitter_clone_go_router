import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/pages/new_tweet.dart';
import 'package:twitter_clone/pages/profile.dart';
import 'package:twitter_clone/pages/sign_up.dart';
import 'package:twitter_clone/pages/login.dart';
import 'package:twitter_clone/pages/welcome.dart';
import 'package:twitter_clone/pages/home.dart';
import 'package:twitter_clone/pages/edit_profile.dart';

class AppRouter {
  static const welcomePath = '/';
  static Widget welcomeScreenWidget(BuildContext context, GoRouterState state) {
    return const WelcomeScreen();
  }

  static const signUpPath = '/create_account';
  static Widget signUpWidget(BuildContext context, GoRouterState state) {
    return const CreateAccountScreen();
  }

  static const loginPath = '/login';
  static Widget loginWidget(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }

  static const homePath = '/home_screen';
  static Widget homeWidget(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }

  static const createTweetPath = '/create_tweet';
  static Widget createTweetWidget(BuildContext context, GoRouterState state) {
    return const AddTweetScreen();
  }

  static const profilePath = '/profile';
  static Widget profileWidget(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }

  static const editProfilePath = '/edit_profile';
  static Widget editProfileWidget(BuildContext context, GoRouterState state) {
    return const EditProfilePage();
  }

  static final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: welcomePath,
      builder: welcomeScreenWidget,
    ),
    GoRoute(path: signUpPath, builder: signUpWidget),
    GoRoute(
      path: loginPath,
      builder: loginWidget,
    ),
    GoRoute(
      path: createTweetPath,
      builder: createTweetWidget,
    ),
    GoRoute(
      path: homePath,
      builder: homeWidget,
    ),
    GoRoute(path: profilePath, builder: profileWidget),
    GoRoute(path: editProfilePath, builder: editProfileWidget)
  ]);

  static GoRouter get router => _router;
}
