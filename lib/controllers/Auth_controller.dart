import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_map/controllers/notificationController.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:google_map/views/auth/verification.dart';
import 'package:twitter_login/twitter_login.dart';

import 'package:google_map/views/auth/loginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  bool _toggle = true;
  bool get toggle => _toggle;
  UserCredential? user;
  // final Stream profile  = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  NotificationController notify = Get.put(NotificationController());
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore dbRef = FirebaseFirestore.instance;

  createUserWithEmail(String email, String password) {
    clearDb();
    EasyLoading.show(status: "Creating Profile, Please wait...", );
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Get.snackbar('User Created Successfully', '',
          backgroundColor: Colors.green, colorText: Colors.white);
    }).then((value) {
      notify.addTokenToFirebase();
      EasyLoading.dismiss();
      Get.to(HomePage());
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  loginWithEmail(String email, String password) {
    clearDb();
    EasyLoading.show(status: "Logging in to your account, Please wait...", );
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
     EasyLoading.dismiss();
     notify.addTokenToFirebase();
      Get.snackbar('Login with Email ', 'Successfully',
          backgroundColor: Colors.blue, colorText: Colors.white);
      Get.to(HomePage());
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  logout() {
    EasyLoading.show(status: "Logging out, Please wait...", );
    auth.signOut().then((value) {
      EasyLoading.dismiss();
      Get.snackbar('Logout Successfully', '',
          backgroundColor: Colors.grey, colorText: Colors.white);
      Get.off(LoginScreen());
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
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
  EasyLoading.show(status: "Signing in with Google, Please wait...", );

  OAuthCredential credential;
    getGoogleCredentials().then((value) async {
      credential = value;
      await auth.signInWithCredential(credential).then((value) {
        notify.addTokenToFirebase();
        user = value;
        Get.snackbar('Login with Google',"Successfully!", backgroundColor: Colors.orange, colorText: Colors.white);
        addUserToFirebase(user!.user!.uid, user!.user!.displayName!, user!.user!.email!,user!.user!.photoURL!);
        EasyLoading.dismiss();
        Get.to(HomePage());
      }).onError((error, stackTrace) {
        Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);
        EasyLoading.dismiss();
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
   EasyLoading.show(status: "Signing in with Github, Please wait...", );
    GithubAuthProvider githubProvider = GithubAuthProvider();
    // Get.to(HomeScreen());
    await auth.signInWithProvider(githubProvider).then((value){
      user = value;
      EasyLoading.dismiss();
      notify.addTokenToFirebase();
      Get.snackbar('Login with Github',"Successfully!", backgroundColor: Colors.black, colorText: Colors.white);
      addUserToFirebase(user!.user!.uid, user!.user!.displayName!, user!.user!.email!,user!.user!.photoURL!);

      Get.to(HomePage());
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);

    });

  }
  signInWithTwitter() async {
    EasyLoading.show(status: "Creating Profile, Please wait...", );
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
        EasyLoading.dismiss();
        notify.addTokenToFirebase();
        Get.snackbar('Login with Twitter',"Successfully!", backgroundColor: Colors.blue, colorText: Colors.white);
        addUserToFirebase("user!.user!.uid", 'user!.user!.displayName!', "user!.user!.email!", user!.user!.photoURL!);
        Get.to(HomePage());
      }).onError((error, stackTrace) {
        Get.snackbar('Failed to login' ,error.toString(), backgroundColor: Colors.red, colorText: Colors.white);

      });

    });





  }
//Sign in with phone
  final otpController = TextEditingController();
var resendToken;
  signInWithPhone() async{
    EasyLoading.show();
    await auth.verifyPhoneNumber(
        phoneNumber: phoneController.text.toString(),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credentials) {
          EasyLoading.dismiss();
        },
        verificationFailed: (FirebaseAuthException ex) {
          EasyLoading.dismiss();
          Get.snackbar(ex.toString(), "message");
        },
        codeSent: sendCode,
        codeAutoRetrievalTimeout: (e) {
          EasyLoading.dismiss();
          Get.snackbar(e.toString(), "message");
        });
  }
sendCode(verificationId, token) {
  EasyLoading.showSuccess('OTP has been sent to your phone ${phoneController.text.toString()}');
  resendToken = token;
  Get.to(Verification(verificationId: verificationId));
  EasyLoading.dismiss();
  update();
}
  ///
  // Future<void> resendOTP( [int? token]) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phoneController.text.toString(),
  //     timeout: const Duration(seconds: 60),
  //     verificationCompleted: (PhoneAuthCredential credential) {
  //       // Auto-retrieval of the OTP completed (e.g., SMS code has been automatically detected).
  //       // You can use the credential to sign in.
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Handle verification failure
  //       print('Verification Failed: ${e.message}');
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       // OTP code has been sent to the phone number
  //       print('Code Sent! Verification ID: $verificationId');
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto-retrieval has timed out
  //       print('Auto Retrieval Timeout: $verificationId');
  //     },
  //     forceResendingToken: token,
  //   );
  // }
  //

forgetPassword(){
    EasyLoading.show();
    auth.sendPasswordResetEmail(email: emailController.text).then((value){
      Get.snackbar('Password reset link has been sent!',"Please Check your email",);

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

fun([int? a]){
    print(a);
}

}

