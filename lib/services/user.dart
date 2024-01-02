import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/main.dart';
import 'package:twitter_clone/models/posts_model.dart';

String uid = auth.currentUser!.uid;

class User {
  Future<String> getName() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String name = userSnapshot['name'];
    return name;
  }

  Future<void> updateName(String newName, context) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'name': newName});
    } catch (e) {
      String title = "Error updating name";
      String content = ("An error occured while updating name.");
      showAlert(context, e, title, content);
    }
  }

  Future<void> updateUserName(String newName, context) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'username': newName});
    } catch (e) {
      String title = "Error updating username";
      String content = ("An error occured while updating username.");
      showAlert(context, e, title, content);
    }
  }

  Future<String> getUserName() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String username = userSnapshot['username'];
    return username;
  }

  Future<void> updateImageURL(profilePicURL, context) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'profilePicURL': profilePicURL});
    } catch (e) {
      String title = "Error updating profile picture";
      String content = ("An error occured while updating profile picture.");
      showAlert(context, e, title, content);
    }
  }

  Future<String> getProfilePicByUID(userUID) async {
    String profilePicURL = '';
    print("this is the userId passed in ${userUID}");

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .get();
      if (userSnapshot.exists) {
        profilePicURL =
            (userSnapshot.data() as Map<String, dynamic>)['profilePicURL'] ??
                '';
        print("this is the profile pic we got ${profilePicURL}");
      }
    } catch (e) {
      // String title = "Error updating profile picture";
      // String content = ("An error occured while updating profile picture.");
      // showAlert(context, e, title, content);
    }
    print("this is the profile pic we are returning ${profilePicURL}");
    return profilePicURL;
  }

  Future<String> getUserBio() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String userBio = userSnapshot['userBio'];
    return userBio;
  }

  Future<void> updateUserBio(String newBio, context) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({'userBio': newBio});
    } catch (e) {
      String title = "Error updating userBio";
      String content = ("An error occured while updating userBio.");
      showAlert(context, e, title, content);
    }
  }

  Future<String> getUserProfilePic() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    String userProfilePic = userSnapshot['profilePicURL'];
    return userProfilePic;
  }

  // Future<String> getUserTweets() async {
  //   DocumentSnapshot tweetsSnapshot = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .where('user', isEqualTo: uid);
  //   String tweets = tweetsSnapshot['tweets'];
  //   return tweets;
  // }

  Future<Map<String, dynamic>> fetchData() async {
    String name = await getName();
    String username = await getUserName();
    String userBio = await getUserBio();
    String userProfilePic = await getUserProfilePic();

    // String tweets = await getUserTweets();
    Map<String, dynamic> userData = {
      'name': name,
      'username': username,
      'userBio': userBio,
      // 'tweets': tweets,
      'profilePicURL': userProfilePic,
    };
    return userData;
  }

  Future<List<PostModel>> getUserPosts() async {
    final snapshot = await FirebaseFirestore.instance.collection("posts").get();
    final userPosts =
        snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList();
    return userPosts;
  }

  getUserPostsData() {
    return getUserPosts();
  }

  Future<List<PostModel>> getUserPostsByUid() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid) // Filter posts by uid
        .get();

    final userPosts =
        snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList();
    return userPosts;
  }

  getUserPostsByUidData() {
    return getUserPostsByUid();
  }
}
