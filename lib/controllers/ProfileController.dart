import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool value) {
    _isLoading = value;
    update();
  }

  String profile = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Stream profileStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final editingController = TextEditingController();

  // Update profile to firebase
  updateProfile() {
    setLoading(true);
    firestore.collection('Users').doc(auth.currentUser!.uid).update({
      'name': nameController.text,
      'phone': phoneController.text,
      'address': addressController.text
    }).then((value) {
      Get.back();
      Get.snackbar('Profile updated Successfully', '');
      setLoading(false);
    });
  }
//popup for image update
  popUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      print('Pick Image From Camera');
                      Get.back();
                    },
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      Get.back();
                    pickGalleryImage(context);
                      print('Pick Image From Gallery');
                    },
                    leading: Icon(Icons.photo),
                    title: Text('Gallery'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final picker = ImagePicker();
  File? image;
//Pick Image from gallery
  Future pickGalleryImage(BuildContext context) async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      image = File(pickedImage.path);

      update();
    }
  }
// Pick image from Camera
  Future pickCameraImage(BuildContext context) async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedImage != null) {
      image = File(pickedImage.path);

      update();
    }
  }

  // Upload image to firebase storage
    uploadImage(BuildContext context)async{
      final ref = await firebaseStorage.ref('Profile Image - '+ auth.currentUser!.uid);
final uploadTask = ref.putFile(File(image!.path));
await Future.value(uploadTask);
final newUrl = await ref.getDownloadURL();

firestore.collection('Users').doc(auth.currentUser!.uid).update({
  'profile': newUrl
}).then((value){
  Get.snackbar('Profile updated Successfully', '');
}).onError((error, stackTrace) {
  Get.snackbar(error.toString(), stackTrace.toString());
});



    }





}
