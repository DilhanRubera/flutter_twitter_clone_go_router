import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/main.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/routes/routes.dart';

Future signUp(name, username, email, password, context) async {
  String userBio = '';
  String profilePicURL = '';
  try {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    String uid = auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'userBio': userBio,
      'profilePicURL': profilePicURL
    });
    GoRouter.of(context).go(AppRouter.homePath);
  } catch (e) {
    String title = "Invalid Email or Password";
    String content = "An error occurred during authentication: $e";
    showAlert(context, e, title, content);
  }
}

Future login(email, password, context) async {
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    GoRouter.of(context).go(AppRouter.homePath);
  } catch (e) {
    //print("Error during authentication: $e");
    String title = "Invalid Email or Password";
    String content = "An error occurred during authentication: $e";
    showAlert(context, e, title, content);
  }
}

Future logout(authStateAsync, context) async {
  try {
    await auth.signOut();
    GoRouter.of(context).go(AppRouter.welcomePath);
  } catch (e) {
    String title = " Logout Error";
    String content = "An error occurred during logout: ";
    showAlert(context, e, title, content);
  }
}

Future<bool> isUsernameTaken(String username) async {
  QuerySnapshot uNameQuerySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: username)
      .get();

  return uNameQuerySnapshot.docs.isEmpty;
}

Future<bool> isEmailTaken(String email) async {
  QuerySnapshot emailQuerySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  return emailQuerySnapshot.docs.isEmpty;
}

showAlert(context, e, title, content) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content + "$e"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      });
}
