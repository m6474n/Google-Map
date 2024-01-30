import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/EmailField.dart';
import 'package:google_map/components/PasswordField.dart';
import 'package:google_map/controllers/Auth_controller.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:google_map/views/auth/forgetPass.dart';
import 'package:google_map/views/auth/registerScreen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GetBuilder(
            init: AuthController(),
            builder: (controller) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login Screen',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      EmailField(
                          lable: 'Email',
                          controller: controller.emailController,
                          prefixIcon: Icons.email),
                      PasswordField(
                          lable: 'Password',
                          obscure: true,
                          controller: controller.passController,
                          prefixIcon: Icons.lock),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                           Get.to(ForgetPassword());
                          },
                          child: Text('Forget Password?'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.loginWithEmail(
                              controller.emailController.text,
                              controller.passController.text);
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.deepPurple,
                          ),
                          child: controller.isLoading == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        child: Center(
                            child: Text(
                          'Or Sign In with',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        )),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  controller.signinWithGoolge();
                                },
                                child: SvgPicture.asset("assets/google.svg",
                                    height: 50)),
                            GestureDetector(
                              onTap: () {
                                controller.signinWithGithub();
                              },
                              child: SvgPicture.asset(
                                "assets/github.svg",
                                height: 50,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  controller.signInWithFacebook();
                                },
                                child: SvgPicture.asset("assets/facebook.svg",
                                    height: 55)),
                            GestureDetector(
                                onTap: () {
                                 controller.signInWithTwitter();
                                  print('Twitter Login');
                                },
                                child: SvgPicture.asset("assets/twitter.svg",
                                    height: 55))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                              text: "Don't have an account.",
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(RegisterScreen());
                                },
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              text: ' Sign up',
                            )
                          ])),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
