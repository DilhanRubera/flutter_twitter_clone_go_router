import 'package:flutter/material.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/main.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String name = '';
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Create a New Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.lightBlue,
                  ),
                ),
                onChanged: (value) => setState(() {
                  name = value;
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: Colors.lightBlue,
                  ),
                ),
                onChanged: (value) => setState(() {
                  username = value;
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.lightBlue,
                  ),
                ),
                onChanged: (value) => setState(() {
                  email = value;
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.lightBlue,
                  ),
                ),
                onChanged: (value) => setState(() {
                  password = value;
                }),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  signUp(name, username, email, password, context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.loginPath);
                },
                child: Text(
                  'Already have an account? Log in.',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
