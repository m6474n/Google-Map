import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:google_map/views/auth/loginScreen.dart';

class SplashService{

  void isLogin(){
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!=null){

      Timer(Duration(seconds: 3),()=>
        Get.to(HomePage())
      );
    }
    else{
      Timer(Duration(seconds: 3),()=>
          Get.to(LoginScreen())
      );
    }

  }



}