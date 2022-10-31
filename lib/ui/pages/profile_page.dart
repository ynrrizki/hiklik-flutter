import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_app/services/user_services.dart';
import 'package:hiklik_app/ui/pages/profile_edit_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dropDownList = const [
      'Update',
      'Delete',
    ];
    String dropdownValue = dropDownList.first;
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

    void _showPicker(
        BuildContext context, CollectionReference reference, bool updateData,
        [int index = 0]) {
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
                      if (updateData) {
                        UserServices.deleteImageGallery(
                          id,
                          field: 'galleryImage',
                          xfile: xfile,
                        );
                      } else {
                        UserServices.uploadImageGallery(
                          id,
                          field: 'galleryImage',
                          xfile: xfile,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Show Camera'),
                    onTap: () async {
                      XFile xfile = await getCameraImage();
                      if (updateData) {
                        UserServices.deleteImageGallery(
                          id,
                          field: 'galleryImage',
                          xfile: xfile,
                        );
                      } else {
                        UserServices.uploadImageGallery(
                          id,
                          field: 'galleryImage',
                          xfile: xfile,
                        );
                      }
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

    void _showFullModal(context, CollectionReference reference,
        dynamic galleryImage, int index) {
      showGeneralDialog(
        context: context,
        barrierDismissible:
            false, // should dialog be dismissed when tapped outside
        barrierLabel: "Modal", // label for barrier
        transitionDuration: const Duration(
            milliseconds:
                500), // how long it takes to popup dialog after button click
        pageBuilder: (_, __, ___) {
          // your widget implementation
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text(
                  "${index}",
                  style: const TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Overpass',
                      fontSize: 20),
                ),
                actions: [
                  IconButton(
                    color: Colors.red,
                    onPressed: () {
                      UserServices.deleteImageGallery(
                        id,
                        field: 'galleryImage',
                        xfile: galleryImage,
                        indexGallery: index,
                      );
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
                elevation: 0.0),
            backgroundColor: Colors.white.withOpacity(0.90),
            body: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xfff8f8f8),
                    width: 1,
                  ),
                ),
              ),
              child: ListView(
                children: [
                  Image.network(galleryImage[index]),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: UserServices.profileCollection.doc(id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = (snapshot.data!.data() as dynamic);
            String username = data['username'] ?? 'username';
            String avatar = data['avatar'] ?? '';
            String name = data['name'] ?? '';
            String description = data['description'] ?? '';
            var galleryImage = data['galleryImage'];
            print('=========================================');
            print(galleryImage);
            print('=========================================');
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showPicker(
                  context,
                  UserServices.profileCollection,
                  false,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.post_add),
              ),
              appBar: AppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0.5,
                title: Text(username),
                centerTitle: true,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 77,
                          width: 77,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatar),
                          ),
                        ),
                        const SizedBox(width: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 30),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileEditPage(),
                                  ),
                                );
                              },
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(description),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(221, 117, 117, 117),
                    height: 3,
                    indent: 1,
                  ),
                  const SizedBox(height: 20),
                  if (galleryImage != "[]")
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 1,
                        ),
                        itemCount: galleryImage.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () => _showFullModal(
                                context,
                                UserServices.profileCollection,
                                galleryImage,
                                index),
                            child: Image.network(
                              galleryImage[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        })
                  else
                    const SizedBox(),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            );
          }
        });
  }
}
