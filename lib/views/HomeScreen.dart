import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/components/PasswordField.dart';
import 'package:google_map/components/cutomButton2.dart';
import 'package:google_map/controllers/Auth_controller.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/views/googleMap/MapScreen.dart';
import 'package:google_map/views/googleMap/PolygonScreen.dart';
import 'package:google_map/views/googleMap/destinationScreen.dart';
import 'package:google_map/views/googleMap/sourceScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // final Controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create route'),
        actions: [
          IconButton(
              onPressed: () {
                Get.find<AuthController>().logout();
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
                      Get.find<MapController>().pageTitle = null;

                      Get.to(MapScreen(
                     title: "Source"
                      ));
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
                      Get.find<MapController>().pageTitle = null;

                      Get.find<MapController>().polylineCoordinates.clear();

                      Get.to(MapScreen(title: 'Destination'));
                      print('destination location');
                    },
                    controller: controller.destinationController,
                    label: 'Destination',
                    prefixIcon: Icons.location_city),
                // SizedBox(height: 12,),
                CustomButton2(
                    label: 'PolyGon Screen', onTap: () {
                      Get.to(PolygonScreen());
                }, isLoading: false)
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
