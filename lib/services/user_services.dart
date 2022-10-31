import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UserServices {
  static CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> createOrUpdate(
    String uid, {
    String? name,
    String? sport,
    String? job,
    String? about,
  }) async {
    await profileCollection.doc(uid).update({
      'name': name,
      'sport': sport,
      'job': job,
      'about': about,
    });
  }

  static Future<void> editImageProfile(String uid,
      {required String field, XFile? xfile}) async {
    File file = File(xfile!.path);
    String fileName = basename(file.path);
    Reference ref = FirebaseStorage.instance.ref('${field}s/').child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    uploadTask.then((res) async {
      final url = await res.ref.getDownloadURL();
      print(
          "==================================================================");
      print(url);
      print(
          "==================================================================");
      profileCollection.doc(uid).update({
        field: url,
      });
    });
  }

  static Future<void> uploadImageGallery(String uid,
      {required String field, XFile? xfile}) async {
    File file = File(xfile!.path);
    String fileName = basename(file.path);
    Reference ref = FirebaseStorage.instance.ref('${field}s/').child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    uploadTask.then((res) async {
      final url = await res.ref.getDownloadURL();
      print(
          "==================================================================");
      print(url);
      print(
          "==================================================================");
      profileCollection.doc(uid).update({
        field: FieldValue.arrayUnion([url]),
      });
    });
  }

  // static Future<void> updateImageGallery(String uid,
  //     {required String field, required XFile xfile, required int index}) async {
  //   File file = File(xfile.path);
  //   String fileName = basename(file.path);
  //   Reference ref = FirebaseStorage.instance.ref('${field}s/').child(fileName);
  //   UploadTask uploadTask = ref.putFile(file);
  //   uploadTask.then((res) async {
  //     final url = await res.ref.getDownloadURL();
  //     print(
  //         "==================================================================");
  //     print(url);
  //     print('\n');
  //     // print(FieldValue.arrayUnion([url]));
  //     print(
  //         "==================================================================");

  //     profileCollection.doc(uid).update({
  //       '${field}': FieldValue.arrayUnion([url]),
  //     });
  //   });
  // }

  static Future<void> deleteImageGallery(String uid,
      {required String field,
      required XFile xfile,
      int indexGallery = 0}) async {
    File file = File(xfile.path);
    String fileName = basename(file.path);
    Reference ref = FirebaseStorage.instance.ref('${field}s/').child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    uploadTask.then((res) async {
      final url = await res.ref.getDownloadURL();
      print(
          "==================================================================");
      print(url);
      print('\n');
      // print(FieldValue.arrayUnion([url]));
      print(
          "==================================================================");

      profileCollection.doc(uid).update({
        // '${field}': FieldValue.delete(),
        field: FieldValue.delete(),
      });
    });
  }

  static Future<void> addAchivement(
    String uid, {
    required String title,
    required String description,
  }) async {
    await profileCollection.doc(uid).update({
      'achivement': {
        'title': title,
        'description': description,
      }
    });
  }
}
