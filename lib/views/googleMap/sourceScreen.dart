// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_map/components/searchField.dart';
// import 'package:google_map/controllers/MapController.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class SourceScreen extends StatelessWidget {
//   const SourceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: GetBuilder(
//       init: MapController(),
//       builder: (controller){
//         return Stack(children: [
//           GoogleMap(
//               markers: Set<Marker>.from(controller.markers),
//               onMapCreated: (GoogleMapController _controller){
//                 controller.completer.complete(_controller);
//               },
//               onTap: (LatLng position){
//                 controller.addMarker('Source', position.latitude, position.longitude, 'Source');
//                 controller.markers.add(Marker(markerId: MarkerId('Source'), position: position, infoWindow: InfoWindow(title: 'Source')));
//                 controller.updateSource(position);
//
//                 },
//               initialCameraPosition: CameraPosition(target: controller.initialCamera))
//           ,SearchField(controller: controller.searchController),
//           Padding(
//               padding:
//               const EdgeInsets.symmetric(vertical: 100, horizontal: 18),
//               child:Get.find<MapController>().searchController.text ==""?Container(): Expanded(
//                 // color: .grey.shade100,
//                 child: ListView.builder(
//                     itemCount: controller.placeList.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.grey.shade100,
//                         child: ListTile(
//                           onTap: () {
//                             controller.updateScreen(
//                               controller.placeList[index]['description'],
//                             );
//                             controller.placeList.clear();
//                             controller.searchController.clear();
//                           },
//                           title: Text(
//                               controller.placeList[index]['description']),
//                         ),
//                       );
//                     }),
//               )),
//
//         ],);
//       },),);
//   }
// }
