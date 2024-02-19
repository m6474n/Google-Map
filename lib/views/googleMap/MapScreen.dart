import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CustomButton.dart';
import 'package:google_map/components/searchField.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapScreen extends StatelessWidget {
  String title;
   MapScreen({super.key, required this.title});

MapController c = Get.put(MapController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(()=>Text('${c.title.value.toString()}'))),
      body: GetBuilder(
        init: MapController(),
        builder: (controller){
          return Stack(children: [


            controller.loadMap(title),
           title == "Route"? Container(): Padding(
             padding: const EdgeInsets.all(18.0),
             child: SearchField(controller: controller.searchController),
           ),
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 100, horizontal: 18),
                child:Get.find<MapController>().searchController.text ==""?Container(): Expanded(
                  // color: .grey.shade100,
                  child: ListView.builder(
                      itemCount: controller.placeList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey.shade100,
                          child: ListTile(
                            onTap: () {
                              controller.updateScreen(
                                controller.placeList[index]['description'],
                              );
                              controller.placeList.clear();
                              controller.searchController.clear();
                            },
                            title: Text(
                                controller.placeList[index]['description']),
                          ),
                        );
                      }),
                )),
          ],);
        },),
      floatingActionButton:title == 'Route'? Container(): Padding(
        padding: const EdgeInsets.all(18),
        child: CustomButton(label: 'Confirm', onTap: () {
          // Get.to(HomePage());
          // Get.find<MapController>().searchController.clear();
          // Get.find<MapController>().clearTitle();
          // Get.find<MapController>().completer = Completer();


        }, isLoading: false,),
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
