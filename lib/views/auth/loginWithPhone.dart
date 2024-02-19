import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/controllers/Auth_controller.dart';
class PhoneLogin extends StatelessWidget {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (controller){
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ Text(
                  'Login with Phone',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInput(
                      controller: controller.phoneController,
                      prefixIcon: Icons.phone, label: 'Enter Phone', ontap: () {  },),
                  CustomButton(label: "Login", onTap: (){
                    controller.signInWithPhone();
                  }, isLoading:false)
                ],),
            ),
          );
        });
  }
}
