import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/components/cutomButton2.dart';
import 'package:google_map/controllers/Auth_controller.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/controllers/ProfileController.dart';
import 'package:google_map/views/ProfileScreens/EditProfile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [TextButton(onPressed: (){
        Get.to(EditProfile(image: Get.find<ProfileController>().profile));
      }, child: Text('Edit Profile'))],),
      body: GetBuilder(
        init: ProfileController(),
        builder: (controller) {
          return StreamBuilder(
              stream: controller.profileStream,
              builder: (context, snapshot) {



                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ));
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Something went wrong, try again later'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No Data Found!'));
                }
                controller.nameController.text = snapshot.data['name'];
                controller.phoneController.text = snapshot.data['phone'];
                controller.addressController.text = snapshot.data['address'];
                controller.profile = snapshot.data['profile'];

                return SafeArea(
                  child: Column(
                    children: [

                      SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(snapshot.data['profile']),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    Reusable(label: 'Name', prefixIcon: Icons.person, value: snapshot.data['name'], ),
                    Reusable(label: 'Email', prefixIcon: Icons.mail, value: snapshot.data['email'], ),
                    Reusable(label: 'Phone', prefixIcon: Icons.phone, value: snapshot.data['phone'], ),
                    Reusable(label: 'Address', prefixIcon: Icons.location_city, value: snapshot.data['address'], ),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomButton2(
          color: Colors.red,
          label: 'Logout',
          onTap: () {
            Get.find<AuthController>().logout();
          },
          isLoading: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Reusable extends StatelessWidget {
  final String label, value;
  IconData prefixIcon;
  final TextEditingController textController = TextEditingController();
   Reusable(
      {super.key,
      required this.label,
      required this.prefixIcon, required this.value,
      });
  @override
  Widget build(BuildContext context) {
    textController.text = value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 18),
      child: TextFormField(
        controller: textController,
        enabled: false,
        decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.deepPurple,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
