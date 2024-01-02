import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String creator;
  final String username;
  final String tweet;
  final Timestamp timestamp;

  PostModel({
    required this.creator,
    required this.username,
    required this.tweet,
    required this.timestamp,
  });

  toJson() {
    return {
      'creator': creator,
      'username': username,
      'tweet': tweet,
      'timestamp': timestamp,
    };
  }

  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PostModel(
      creator: data['creator'],
      username: data['username'],
      tweet: data['tweet'],
      timestamp: data['timestamp'],
    );
  }
}
