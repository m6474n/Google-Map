import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/EmailField.dart';
import 'package:google_map/components/PasswordField.dart';
import 'package:google_map/controllers/Auth_controller.dart';
import 'package:google_map/views/auth/loginScreen.dart';
import 'package:google_map/views/auth/registerScreen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Register Screen',
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
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.createUserWithEmail(
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
                                'Register',
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
                        children: [SvgPicture.asset("assets/google.svg")],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                            text: "Already have an account.",
                            children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(LoginScreen());
                              },
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            text: ' Login',
                          )
                        ])),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
