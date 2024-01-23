import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/controllers/PolygonController.dart';

class PolygonScreen extends StatefulWidget {
  @override
  _PolygonScreenState createState() => _PolygonScreenState();
}

class _PolygonScreenState extends State<PolygonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: PolygonController(),
        builder: (controller) {
          return Stack(
            children: [controller.PolygonMap()],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(onPressed: (){
          Get.find<PolygonController>().drawLine();
        }, child: Text('Draw'),),
    SizedBox(height: 12,),
    FloatingActionButton(
        child: const Text('Clear'),
        onPressed: () {
      Get.find<PolygonController>().clearMarkers();
    }),
      ],),
      // floatingActionButton: FloatingActionButton(
      //     child: const Text('Clear'),
      //     onPressed: () {
      //   Get.find<PolygonController>().clearMarkers();
      // }),
    );
  }
}
