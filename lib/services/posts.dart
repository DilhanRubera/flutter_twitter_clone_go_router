import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/services/user.dart';

class Posts {
  String uid = auth.currentUser!.uid;

  Future createTweet(tweet, context) async {
    try {
      String username = await User().getUserName();

      await FirebaseFirestore.instance.collection("posts").add({
        'creator': uid,
        'username': username,
        'tweet': tweet,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      String title = "Unable to post tweet";
      String content = "Error in posting tweet.Try again";
      showAlert(context, e, title, content);
    }
  }

  // final postsPorvider = StreamProvider<List<PostModel>>((ref) {
  //   return FirebaseFirestore.instance
  //       .collection("posts")
  //       .where('user', isEqualTo: uid)
  //       .snapshots()
  //       .map(postListFromSnapshot);
  // });

  // List<PostModel> postListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return PostModel(
  //       id: doc.id,
  //       tweet: doc.data()['tweet'] ?? '',
  //       user: doc.data()['user'] ?? '',
  //       timestamp: doc.data()['timestamp'] ?? 0,
  //     );
  //   }).toList();
  // }
}
