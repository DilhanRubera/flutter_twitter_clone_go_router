import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/services/posts.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({Key? key}) : super(key: key);

  @override
  _AddTweetScreenState createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  String tweet = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).go(AppRouter.homePath),
            icon: Icon(
              Icons.logout,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              Posts().createTweet(tweet, context);
              GoRouter.of(context).go(AppRouter.homePath);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: null,
              decoration: InputDecoration(
                hintText: "What's happening?",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) => setState(() {
                tweet = value;
              }),
              maxLines: null,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
