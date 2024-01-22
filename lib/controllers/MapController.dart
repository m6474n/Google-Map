import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/views/googleMap/MapScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    // id = uuid.v4();
    // moveToCurrentLocation();
    super.onInit();
  }

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  PointLatLng? source;
  PointLatLng? destination;

// var id;
// var uuid = Uuid();
  LatLng initialCamera = LatLng(32.5750722, 74.0072031);
  Completer<GoogleMapController> completer = Completer();
  FirebaseFirestore ref = FirebaseFirestore.instance;
  List<Marker> markers = [];

// Load map
  loadMap(String title) {
    return StreamBuilder(
        stream: ref.collection('Markers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            markers.add(Marker(
                markerId: MarkerId(i.toString()),
                position: LatLng(snapshot.data!.docs[i]['lat'],
                    snapshot.data!.docs[i]['long']),
                infoWindow: InfoWindow(title: snapshot.data!.docs[i]['info'])));
          }
          return GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              polylines: {
                Polyline(
                    polylineId: PolylineId('route'),
                    points: polylineCoordinates,
                    width: 3,
                    color: Colors.deepPurple)
              },
              onTap: (LatLng position) {
                addMarker(title, position.latitude, position.longitude, title);
                if (title == 'Source') {
                  // markers.add(Marker(markerId: MarkerId('Source'),position: LatLng(position.latitude,position.longitude), infoWindow: InfoWindow(title: 'Source')));
                  updateSource('Source Updated', position);
                }
                if (title == 'Destination') {
                  // markers.add(Marker(markerId: MarkerId('Destination'),position: LatLng(position.latitude,position.longitude), infoWindow: InfoWindow(title: 'Destination')));

                  updateDestination("Destination Updated", position);
                }
                update();
              },
              onMapCreated: (GoogleMapController controller) {
                completer.complete(controller);
              },
              initialCameraPosition:
                  CameraPosition(target: initialCamera, zoom: 12));
        });

    // return StreamBuilder(
    //     stream: ref.collection('markers').snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       return GoogleMap(
    //           mapType: MapType.normal,
    //           markers: Set<Marker>.of(markers),
    //           onMapCreated: (GoogleMapController controller) {
    //             completer.complete(controller);
    //           },
    //           initialCameraPosition: CameraPosition(target: initialCamera));
    //     });
  }

  //Get current location
  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
          'Location permission disabled!', 'Turn on the location service');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) ;
    {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied!', 'Turn on the location service');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location permissions are permanently denied',
          'We can not request the permissions');
    }
    return Geolocator.getCurrentPosition();
  }

  //Move camera to current location

  moveToCurrentLocation() async {
    await getCurrentLocation().then((value) async {
      initialCamera = LatLng(value.latitude, value.longitude);
      CameraPosition newCameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 12);
      GoogleMapController controller = await completer.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      // markers.add(Marker(markerId: MarkerId('1'),position: LatLng(value.latitude,value.longitude), infoWindow:const InfoWindow(title: 'My Location')));
    });
    update();
  }

  // add marker

  addMarker(String id, double lat, double long, String title) {
    ref
        .collection('Markers')
        .doc(title)
        .set({"id": id, 'info': title, 'long': long, 'lat': lat});

    // markers.add(Marker(markerId: MarkerId(id), position: LatLng(lat, long), infoWindow: InfoWindow(title: title)));
  }

// update source
  updateSource(String text, LatLng position) {
    sourceController.text = text;
    source = PointLatLng(position.latitude, position.longitude);
    update();
  }

// update destination
  updateDestination(String text, LatLng position) {
    destination = PointLatLng(position.latitude, position.longitude);
    destinationController.text = text;
    update();
  }

  //PolyLine service
  void getPolyPoints(PointLatLng source, PointLatLng destination) async {
    PolylinePoints polylinePoints = new PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCGXjH2olWHaRbJBH4SRNGmYfX60skyWs8', source, destination);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    update();
  }

//generate route
  generateRoute() {
    markers.clear();
    if (source == null || destination == null) {
      Get.snackbar('Invalid Source or Destination!', "Enter valid Location");
    } else {
      getPolyPoints(source!, destination!);
      Get.to(MapScreen(title: "Route"));
    }

    print(source);
  }

  //add point to polygon
}
