import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:twitter_login/twitter_login.dart';

import 'package:google_map/views/auth/loginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  bool _toggle = true;
  bool get toggle => _toggle;
  UserCredential? user;
  // final Stream profile  = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();

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
      Get.to(HomePage());
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
      Get.snackbar('Login with Email ', 'Successfully',
          backgroundColor: Colors.blue, colorText: Colors.white);
      Get.to(HomePage());
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
      Get.off(LoginScreen());
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
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
        user = value;
        Get.snackbar('Login with Google',"Successfully!", backgroundColor: Colors.orange, colorText: Colors.white);
        addUserToFirebase(user!.user!.uid, user!.user!.displayName!, user!.user!.email!,user!.user!.photoURL!);

        Get.to(HomePage());
      }).onError((error, stackTrace) {
        Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);

      });
    });
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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

 signinWithGithub()async{
    setLoading(true);
    GithubAuthProvider githubProvider = GithubAuthProvider();
    // Get.to(HomeScreen());
    await auth.signInWithProvider(githubProvider).then((value){
      user = value;
      setLoading(false);
      Get.snackbar('Login with Github',"Successfully!", backgroundColor: Colors.black, colorText: Colors.white);
      addUserToFirebase(user!.user!.uid, user!.user!.displayName!, user!.user!.email!,user!.user!.photoURL!);

      Get.to(HomePage());
    }).onError((error, stackTrace) {
      Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);

    });

  }
  signInWithTwitter() async {
    setLoading(true);
    // Create a TwitterLogin instance
    final twitterLogin =  TwitterLogin(
        apiKey: 'NzbGtzswJ2T1HIkgTRIOF0a5i',
        apiSecretKey:'gX3HS3wPBsnXIqNgrXEszDpIetyyAce3Pm1COl1l0RjsnEHYn1',
        redirectURI: 'flutter-twitter-login://'
    );

    await twitterLogin.login().then((value)async{
      final twitterCrenentials = TwitterAuthProvider.credential(accessToken: value.authToken!, secret: value.authTokenSecret!);

      await auth.signInWithCredential(twitterCrenentials).then((value) {
        user = value;
        setLoading(false);
        Get.snackbar('Login with Twitter',"Successfully!", backgroundColor: Colors.blue, colorText: Colors.white);
        addUserToFirebase(user!.user!.uid, user!.user!.displayName!, user!.user!.email!," user!.user!.photoURL!");
        Get.to(HomePage());
      }).onError((error, stackTrace) {
        Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);

      });

    });





  }


  /// Firebase Database

addUserToFirebase(String id, String name, String email, String profile,){
    dbRef.collection("Users").doc(id).set({
      'id': id,
      'name': name,
      'email': email,
      'phone': '',
      'address': '',
      'profile':profile
    });
}





}
