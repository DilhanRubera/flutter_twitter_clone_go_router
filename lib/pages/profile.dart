import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/services/user.dart';
import 'package:twitter_clone/services/posts.dart';
import 'package:twitter_clone/models/posts_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  Posts posts = Posts();

  String profilePicURLTest =
      "https://firebasestorage.googleapis.com/v0/b/twitter-clone-distro3-demo.appspot.com/o/profile_pics%2Favatar_spirited.png?alt=media&token=3a020bf3-c8b1-4029-bad9-e5391a83d1d7";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.blue,
          ),
          actions: [
            FloatingActionButton(
                onPressed: () => GoRouter.of(context).go(AppRouter.homePath),
                child: Icon(Icons.arrow_back)),
          ]),
      body: FutureBuilder(
          future: User().fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data;
              String name = data?['name'] ?? 'default name';
              String username = data?['username'] ?? 'default name';
              String userBio = data?['userBio'] ?? 'default bio';
              String profilePicURL = data?['profilePicURL'] ?? '';
              String encodedProfilePicURL = Uri.encodeFull(profilePicURL);

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 200,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: NetworkImage(data?['cover_image']),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(profilePicURL),
                          ),
                          // Image(
                          //   image: NetworkImage(profilePicURL),
                          //   fit: BoxFit.cover,
                          // ),
                          // Image.network(
                          //   profilePicURL,
                          //   fit: BoxFit.cover,
                          // ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '@$username ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 400),
                          ElevatedButton(
                              onPressed: () => GoRouter.of(context)
                                  .go(AppRouter.editProfilePath),
                              child: Text('Edit Profile'))
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          userBio,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                    Divider(),
                    Expanded(
                      child: FutureBuilder<List<PostModel>>(
                          future: User().getUserPostsByUidData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: THIS DOESNT WORKKK');
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: 450,
                                              child: Card(
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: ListTile(
                                                      // leading: CircleAvatar(
                                                      //   radius: 20,
                                                      //   //backgroundImage:
                                                      // ),
                                                      title: Text(
                                                        '@$username',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      subtitle: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              '${snapshot.data![index].tweet}\n${snapshot.data![index].timestamp.toDate()}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14))))))));
                                },
                              );
                            }
                          }),
                    ),
                  ]);
            }
          }),
    );
  }
}
