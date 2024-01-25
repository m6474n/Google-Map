import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/controllers/ProfileController.dart';

class EditProfile extends StatelessWidget {
  final String image;
  const EditProfile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // controller.nameController.text = snapshot.data['name'];
    // controller.phoneController.text = snapshot.data['phone'];
    // controller.addressController.text = snapshot.data['address'];
    // controller.profile= snapshot.data['profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: GetBuilder(
        init: ProfileController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                        child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: controller.image !=null? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            image: DecorationImage(
                                image: FileImage(File(controller.image!.path)),
                                fit: BoxFit.cover)),
                      ) :image == null || image == ""
                          ? Center(
                          child: Icon(
                            Icons.person,
                            size: 52,
                            color: Colors.deepPurple,
                          ))
                          : Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover)),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: GestureDetector(
                          onTap: () {
                            controller.popUp(context);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20)),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                CustomInput(
                    controller: controller.nameController,
                    label: 'Name',
                    prefixIcon: Icons.person,
                    ontap: () {}),
                SizedBox(
                  height: 8,
                ),
                CustomInput(
                    controller: controller.phoneController,
                    label: 'Phone',
                    prefixIcon: Icons.phone,
                    ontap: () {}),
                SizedBox(
                  height: 8,
                ),
                CustomInput(
                    controller: controller.addressController,
                    label: 'Address',
                    prefixIcon: Icons.location_city,
                    ontap: () {}),
                SizedBox(
                  height: 8,
                )
                // CustomInput(controller: controller.Controller, label: 'Name', prefixIcon: Icons.person, ontap: (){})
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomButton(
          label: 'Update Profile',
          onTap: () {
            Get.find<ProfileController>().updateProfile();
            Get.find<ProfileController>().uploadImage(context);

          },
          isLoading: Get.find<ProfileController>().isLoading,
        ),
      ),
    );
  }
}
