// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_map/components/searchField.dart';
// import 'package:google_map/controllers/MapController.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class DestinationScreen extends StatelessWidget {
//    DestinationScreen({super.key});
// DestinationController destinationController = Get.put(DestinationController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: GetBuilder(
//       init: MapController(),
//       builder: (controller){
//         return Stack(children: [
//        GoogleMap(
//          markers: Set<Marker>.from(controller.markers),
//            onMapCreated: (GoogleMapController _controller){
//              controller.completer.complete(_controller);
//            },
//            onTap: (LatLng position){
//              controller.addMarker('Destination', position.latitude, position.longitude, 'Destination');
//              controller.markers.add(Marker(markerId: MarkerId('Destination'), position: position, infoWindow: InfoWindow(title: 'Destinaion')));
//
//              controller.updateDestination(position);
//            },
//            initialCameraPosition: CameraPosition(target: controller.initialCamera))
//           ,Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SearchField(controller:  destinationController.searchController),
//           ),
//           Padding(
//               padding:
//               const EdgeInsets.symmetric(vertical: 100, horizontal: 18),
//               child:destinationController.searchController.text ==""?Container(): Expanded(
//                 // color: .grey.shade100,
//                 child: ListView.builder(
//                     itemCount: destinationController.placeList.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         color: Colors.grey.shade100,
//                         child: ListTile(
//                           onTap: () {
//                            destinationController.updateScreen(
//                               controller.placeList[index]['description'],
//                             );
//                            destinationController.placeList.clear();
//                            destinationController.searchController.clear();
//                           },
//                           title: Text(
//                               destinationController.placeList[index]['description']),
//                         ),
//                       );
//                     }),
//               )),
//
//         ],);
//       },),);
//   }
// }
