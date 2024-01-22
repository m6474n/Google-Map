import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/views/HomeScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapScreen extends StatelessWidget {
  String title;
   MapScreen({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: GetBuilder(
        init: MapController(),
        builder: (controller){
          return Stack(children: [
            controller.loadMap(title)
          ],);
        },),
      floatingActionButton:title == 'Route'? Container(): Padding(
        padding: const EdgeInsets.all(18),
        child: CustomButton(label: 'Confirm', onTap: () {
          Get.back();

        }, isLoading: false,),
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
