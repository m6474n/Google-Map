import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/views/HomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  bool _toggle = true;
  bool get toggle => _toggle;

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore dbRef = FirebaseFirestore.instance;

  createUserWithEmail(String email, String password) {
    clearDb();
    setLoading(true);
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Get.snackbar('User Created Successfully', '',
          backgroundColor: Colors.green, colorText: Colors.white);
    }).then((value) {
      setLoading(false);
      Get.to(HomeScreen());
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  loginWithEmail(String email, String password) {
    clearDb();
    setLoading(true);
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      setLoading(false);
      Get.snackbar('Login Successfully', '',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.to(HomeScreen());
    }).onError((error, stackTrace) {
      setLoading(false);
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  logout() {
    auth.signOut().then((value) {
      Get.snackbar('Logout Successfully', '',
          backgroundColor: Colors.grey, colorText: Colors.white);
      Get.back();
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
  }

  Future getGoogleCredentials() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return credentials;
  }

  signinWithGoolge() {
  clearDb();
    OAuthCredential credential;
    getGoogleCredentials().then((value) async {
      credential = value;
      await auth.signInWithCredential(credential).then((value) {
        Get.to(HomeScreen());
      });
    });
  }

  setLoading(bool value) {
    _isLoading = value;
    update();
  }

  obscureToggle() {
    _toggle = !_toggle;
    update();
  }
  clearDb(){
    FirebaseFirestore.instance.collection('Markers').doc('Source').delete();
    FirebaseFirestore.instance.collection('Markers').doc('Destination').delete();
    update();
  }
}
