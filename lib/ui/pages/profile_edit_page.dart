import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiklik_app/services/user_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textNameController = TextEditingController();
    TextEditingController textSportController = TextEditingController();
    TextEditingController textJobController = TextEditingController();
    TextEditingController textAboutController = TextEditingController();
    Future<File> imageFile;
    final picker = ImagePicker();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // var id = 'FwksOedMRRaGBJN6zsyWUSohHNK2';
    // var id = 'ZcCkQZqaqtN46LPxde7N8xp5Com2';
    var id = 'xutIwR0aJdSawPxISw39n7hxJ0g2';

    Future getImage() async {
      return await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
    }

    Future getCameraImage() async {
      return await ImagePicker.platform
          .getImageFromSource(source: ImageSource.camera);
    }

    void _showPicker(BuildContext context, CollectionReference reference) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: SizedBox(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Show Gallery'),
                    onTap: () async {
                      XFile xfile = await getImage();
                      UserServices.editImageProfile(
                        id,
                        field: 'avatar',
                        xfile: xfile,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Show Camera'),
                    onTap: () async {
                      XFile xfile = await getCameraImage();
                      UserServices.editImageProfile(
                        id,
                        field: 'avatar',
                        xfile: xfile,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          StreamBuilder<DocumentSnapshot>(
              stream: UserServices.profileCollection.doc(id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = (snapshot.data!.data() as dynamic);
                  String avatar = data['avatar'] ?? '';
                  textNameController.text = data['name'] ?? '';
                  textSportController.text = data['sport'] ?? '';
                  textJobController.text = data['job'] ?? '';
                  textAboutController.text = data['about'] ?? '';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  avatar != null ? NetworkImage(avatar) : null,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showPicker(
                                    context,
                                    UserServices.profileCollection,
                                  ),
                                  icon: const SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(
                              controller: textNameController,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 50),
                            TextField(
                              controller: textSportController,
                              decoration: const InputDecoration(
                                hintText: 'Sport',
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 50),
                            TextField(
                              controller: textJobController,
                              decoration: const InputDecoration(
                                hintText: 'Job',
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 50),
                            TextField(
                              controller: textAboutController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'About',
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                /// UPDATE DATA
                                UserServices.createOrUpdate(
                                  id,
                                  name: textNameController.text,
                                  sport: textSportController.text,
                                  job: textJobController.text,
                                  about: textAboutController.text,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      const Text('Berhasil Menyimpan Data!'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height -
                                              100,
                                      right: 20,
                                      left: 20),
                                ));
                              },
                              child: const Text('Save'),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
              }),
        ],
      ),
    );
  }
}
