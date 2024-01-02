import 'package:flutter/material.dart';
import 'package:twitter_clone/services/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

String uid = auth.currentUser!.uid;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String imagePath = '';
  FirebaseStorage storage = FirebaseStorage.instance;
  Uint8List selectedImageInBytes = Uint8List(0);
  String selectFile = '';
  String imageUri = '';

  updateProfile(name, username, userBio) {
    User().updateName(name, context);
    User().updateUserName(username, context);
    User().updateUserBio(userBio, context);
    // User().updateImageURL(imageUri, context);
    uploadFile();

    GoRouter.of(context).go(AppRouter.profilePath);
  }

  chooseProfilePic(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes ?? Uint8List(0);
      });
    }
  }

  uploadFile() async {
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child('/' + selectFile);

      final metadate =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putData(selectedImageInBytes, metadate);

      await uploadTask.whenComplete(() => null);
      imageUri = await ref.getDownloadURL();
      // User().updateImageURL(imageUri, context);

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({'profilePicURL': imageUri});
      } catch (e) {
        // String title = "Error updating profile picture";
        // String content = ("An error occured while updating profile picture.");
        //  showAlert(context, e, title, content);
      }
      print('image uri: $imageUri');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            String name = data?['name'] ?? 'default name';
            String username = data?['username'] ?? 'default name';
            String userBio = data?['userBio'] ?? 'default bio';
            //  String profilePicURL = data?['profilePicURL'] ?? '';

            return AlertDialog(
              title: Text('Edit Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        chooseProfilePic(true);
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imagePath.isEmpty
                            ? null
                            : FileImage(File(imagePath)),
                        child: imagePath.isEmpty
                            ? Icon(
                                Icons.camera_alt,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    TextFormField(
                        initialValue: name,
                        onChanged: (value) {
                          name = value;
                        }),
                    TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'Edit username'),
                        initialValue: username,
                        onChanged: (value) {
                          username = value;
                        }),
                    TextFormField(
                        decoration: const InputDecoration(hintText: 'Edit Bio'),
                        initialValue: userBio,
                        onChanged: (value) {
                          userBio = value;
                        }),
                    ElevatedButton(
                        onPressed: () {
                          updateProfile(name, username, userBio);
                        },
                        child: Text('Save')),
                    ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).go(AppRouter.profilePath);
                        },
                        child: Text('Cancel'))
                  ],
                ),
              ),
            );
          }
        });
  }
}
