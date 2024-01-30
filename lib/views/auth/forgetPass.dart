import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/EmailField.dart';
import 'package:google_map/controllers/Auth_controller.dart';
class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (controller){return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ Text(
            'Forget Password',
            style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
            SizedBox(
              height: 30,
            ),
            EmailField(
                lable: 'Enter Email',
                controller: controller.emailController,
                prefixIcon: Icons.email),],),
      ),
    );});
  }
}
