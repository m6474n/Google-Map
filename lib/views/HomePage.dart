import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/components/cutomButton2.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/controllers/ProfileController.dart';
import 'package:google_map/views/ProfileScreens/ProfileScreen.dart';
import 'package:google_map/views/googleMap/MapScreen.dart';
import 'package:google_map/views/googleMap/PolygonScreen.dart';

import '../controllers/Auth_controller.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
AuthController _controller = Get.put(AuthController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
            indicatorColor: Colors.deepPurple,

            children: [
            StreamBuilder( stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
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

             return DrawerHeader(
                  decoration: BoxDecoration(color: Colors.deepPurple, image: DecorationImage(image: NetworkImage(snapshot.data!['profile']),fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black87, BlendMode.multiply))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!['profile']),
                          radius: 32,
                        ),
                      ),
                      ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(_controller.auth.currentUser!.photoURL.toString()),
                        //   radius: 36,
                        // ),
                        title: Text(
                          snapshot.data!['name'],
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          snapshot.data!['email'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ));}),
              Padding(
                padding: const EdgeInsets.only(left:32.0),
                child: ListTile(
                  onTap: (){
                    Get.to(ProfileScreen());
                  },
                  leading: Icon(Icons.person, color: Colors.deepPurple,),title: Text('Profile'),),
              ), Padding(
                padding: const EdgeInsets.only(left:32.0),
                child: ListTile(leading: Icon(Icons.help, color: Colors.grey,),title: Text('help'),),
              ), Padding(
                padding: const EdgeInsets.only(left:32.0),
                child: ListTile(
                  onTap: (){
                    _controller.logout();
                  },
                  leading: Icon(Icons.logout_rounded, color: Colors.red,),title: Text('Logout'),),
              )
            ]),


      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
               _controller.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: GetBuilder(
        init: MapController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
                child: Column(
              children: [
                CustomInput(
                    ontap: () {
                      Get.find<MapController>().markers.clear();
                      Get.find<MapController>().polylineCoordinates.clear();
                      Get.find<MapController>().title(Get.find<MapController>().sourceController.text);

                      Get.to(MapScreen(title: 'Source'));
                      print('source Location');
                    },
                    controller: controller.sourceController,
                    label: 'Source',
                    prefixIcon: Icons.my_location),
                SizedBox(
                  height: 12,
                ),
                CustomInput(
                    ontap: () {
                      Get.find<MapController>().markers.clear();
                      Get.find<MapController>().title(Get.find<MapController>().destinationController.text);


                      Get.find<MapController>().polylineCoordinates.clear();
                      Get.to(MapScreen(title: 'Destination'));
                      print('destination location');
                    },
                    controller: controller.destinationController,
                    label: 'Destination',
                    prefixIcon: Icons.location_city),
                // SizedBox(height: 12,),
                CustomButton2(
                  color: Colors.grey,
                    label: 'PolyGon Screen',
                    onTap: () {
                      Get.to(PolygonScreen());
                    },
                    isLoading: false),

              ],
            )),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomButton(
          isLoading: false,
          label: 'Generate',
          onTap: () {
            Get.find<MapController>().polylineCoordinates.clear();
            Get.find<MapController>().completer = Completer();
            Get.find<MapController>().generateRoute();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
