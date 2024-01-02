import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/services/user.dart';
import 'package:twitter_clone/models/posts_model.dart';

String uid = auth.currentUser!.uid;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);

    return FutureBuilder(
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
            String name = data?['name'] ?? 'defaultName';
            String username = data?['username'] ?? 'defaultUsername';
            String profilePicURL = data?['profilePicURL'] ?? '';
            return Scaffold(
              appBar: AppBar(
                title:
                    const Text('Home', style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.blue,
                ),
              ),
              drawer: Drawer(
                  child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(profilePicURL),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(name),
                  ),
                  ListTile(title: Text('@${username}')),
                  ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.blue),
                      title: Text('Profile'),
                      onTap: () {
                        GoRouter.of(context).go(AppRouter.profilePath);
                      }),
                  ListTile(
                      leading: Icon(Icons.logout, color: Colors.blue),
                      title: Text('Logout '),
                      onTap: () {
                        logout(authStateAsync, context);
                      })
                ],
              )),
              body: Column(children: [
                Expanded(
                  child: FutureBuilder<List<PostModel>>(
                      future: User().getUserPostsData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: THIS DOESNT WORKKK${snapshot.error}');
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No tweets yet!'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: 450,
                                          child: Card(
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListTile(
                                                leading: FutureBuilder<String>(
                                                    future: User()
                                                        .getProfilePicByUID(
                                                            snapshot
                                                                .data![index]
                                                                .creator),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Icon(Icons
                                                            .error); // Placeholder for error
                                                      } else {
                                                        String profilePicData =
                                                            snapshot.data!;
                                                        String
                                                            usersProfilePicURL =
                                                            profilePicData;
                                                        print(
                                                            'This got printed ${usersProfilePicURL}');
                                                        return CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot
                                                                        .data!));
                                                      }
                                                    }),
                                                title: Text(
                                                  '@${snapshot.data![index].username}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        '${snapshot.data![index].tweet}\n${snapshot.data![index].timestamp.toDate()}',
                                                        style: TextStyle(
                                                            fontSize: 14))),
                                              )))));
                            },
                          );
                        }
                      }),
                ),
                ElevatedButton(
                    onPressed: () =>
                        GoRouter.of(context).go(AppRouter.createTweetPath),
                    child: const Text('Tweet'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    )),
              ]),
            );
          }
        });
  }
}
