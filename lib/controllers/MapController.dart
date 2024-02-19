import 'dart:async';
import 'dart:convert';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:google_map/services/NotificationService.dart';
import 'package:google_map/services/background_services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/views/googleMap/MapScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class MapController extends GetxController {
  NotificationService services = NotificationService();
  BackgroundServices bgServices = BackgroundServices();
  @override
  void onInit() {
    // TODO: implement onInit
    bgServices.initService();
      Geolocator.getPositionStream().listen((event) {
        currentValue = event;
        update();
      });
    searchController.addListener(() {
      onChanged();
    });
    FirebaseInstallations.instance.getId().then((value) {
      print(value);
    });

    tractLocation();
    // id = uuid.v4();
    // moveToCurrentLocation();
    super.onInit();
  }

  RxString title = 'Location'.obs;
  var currentValue ;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  PointLatLng? source;
  PointLatLng? destination;
  LatLngBounds? bounds;
// var id;
// var uuid = Uuid();
  LatLng initialCamera = LatLng(32.5750722, 74.0072031);
String value = "Location";
  final searchController = TextEditingController();
  Completer<GoogleMapController> completer = Completer();
  FirebaseFirestore ref = FirebaseFirestore.instance;
  List<Marker> markers = [];
  String? pageTitle;

// Load map
  loadMap(String title) {
    if (title == 'Route') {
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
                  infoWindow:
                      InfoWindow(title: snapshot.data!.docs[i]['info'])));
            }
            return GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(markers),
                polylines: {
                  Polyline(
                      polylineId: PolylineId('route'),
                      points: polylineCoordinates,
                      width: 3,
                      color: Colors.deepPurple)
                },
                onMapCreated: (GoogleMapController controller) {
                  if (completer.isCompleted) {
                    completer.complete(controller);
                  }
                  update();
                },
                initialCameraPosition:
                    CameraPosition(target: initialCamera, zoom: 12));
          });
    }

    return GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers),
        onTap: (LatLng position) {
          addMarker(title, position.latitude, position.longitude, title);

          if (title == 'Source') {
            updateSource(position);
            print(source);
          }
          if (title == 'Destination') {
            print(destination);

            updateDestination(position);
          }
          update();
        },
        onMapCreated: (GoogleMapController controller) {
          completer.complete(controller);
        },
        initialCameraPosition: CameraPosition(target: initialCamera, zoom: 12));
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
    });
    update();
  }

  // add marker

  addMarker(String id, double lat, double long, String title) {
    ref
        .collection('Markers')
        .doc(title)
        .set({"id": id, 'info': title, 'long': long, 'lat': lat});
  }

// update source
  updateSource(LatLng position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    markers.add(Marker(
        markerId: MarkerId('Source'),
        position: position,
        infoWindow: InfoWindow(title: 'Source')));
    sourceController.text =
        "${placemark.last.street}, ${placemark.last.administrativeArea}, ${placemark.last.country}";
    title(
        "${placemark.last.street}, ${placemark.last.administrativeArea}, ${placemark.last.country}");
    source = PointLatLng(position.latitude, position.longitude);
    update();
  }

// update destination
  updateDestination(LatLng position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    markers.add(Marker(
        markerId: MarkerId('Destination'),
        position: position,
        infoWindow: InfoWindow(title: 'Destination')));
    title(
        "${placemark.last.street}, ${placemark.last.administrativeArea}, ${placemark.last.country}");
    destination = PointLatLng(position.latitude, position.longitude);
    destinationController.text =
        "${placemark.last.street}, ${placemark.last.administrativeArea}, ${placemark.last.country}";
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
    setBounds();
    if (source == null || destination == null) {
      Get.snackbar('Invalid Source or Destination!', "Enter valid Location");
    } else {
      getPolyPoints(source!, destination!);
      Get.to(MapScreen(title: "Route"));
    }

    print(source);
  }

  //Bounds
  setBounds() async {
    LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(source!.latitude, source!.longitude),
        northeast: LatLng(destination!.latitude, destination!.longitude));
    GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    update();
  }

  //search

  var uuid = Uuid();
  String _sessionToken = "112233";
  List<dynamic> placeList = [];

  onChanged() {
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
      update();
    }
    getSuggestions(searchController.text);
  }

  getSuggestions(String input) async {
    String apiKey = "AIzaSyCGXjH2olWHaRbJBH4SRNGmYfX60skyWs8";
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$apiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    print(response.body.toString());

    if (response.statusCode == 200) {
      placeList = jsonDecode(response.body.toString())['predictions'];
    } else {
      throw Exception("Failed to get data");
    }

    update();
  }
  //update screen on search

  updateScreen(
    String address,
  ) async {
    List locals = await locationFromAddress(address);
    print(locals.last.longitude);
    CameraPosition newCameraPosition = CameraPosition(
        target: LatLng(locals.last.latitude, locals.last.longitude), zoom: 12);
    GoogleMapController controller = await completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));

    // searchController.text = address;

    update();
  }

  Marker myMarker = Marker(
      markerId: MarkerId('99'),
      position: LatLng(0, 0),
      icon: BitmapDescriptor.defaultMarkerWithHue(4.9),
      infoWindow: InfoWindow(title: 'You'));

  /// live location tracking
  tractLocation() async {
    await Geolocator.getPositionStream().listen((value) async {
      addMarker('99', value.latitude, value.longitude, "You");
      CameraPosition newCamerPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 12);
      GoogleMapController _controller = await completer.future;
      _controller.animateCamera(CameraUpdate.newCameraPosition(newCamerPosition));
    });

    update();
  }


  getLocation()async{
    await Geolocator.getPositionStream().listen((event) {
      value = "${event.latitude}, ${event.longitude}";
      print(event.toString());
    });
  }



  clearTitle() {
    title('Location');
    update();
  }

  @override
  void onClose() {
    // TODO: implement dispose
    searchController.dispose();

    super.dispose();
  }
}
