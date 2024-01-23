import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class PolygonController extends GetxController {
  Completer<GoogleMapController> completer = Completer();
  List<Marker> markers = [];
  Set<Polygon> polygons = {};
  final searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    controller = controller;
    update();
  }

  PolygonMap() {
    return GoogleMap(
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        completer.complete(controller);
      },
      markers: Set<Marker>.from(markers),
      polygons: polygons,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.4219983, -122.084), // Initial map center
        zoom: 12.0,
      ),
      onTap: onMapTapped,
    );
  }

  onMapTapped(LatLng position) {
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        onTap: () => onMarkerTapped(position),
      ),
    );
    update();
  }

  clearMarkers() {
    markers.clear();
    polygons.clear();

    update();
  }

  onMarkerTapped(LatLng position) {
    if (markers[0].position == position) {
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );
      drawLine();
      update();
    }
  }

  drawLine() {
    for (int i = 0; i < markers.length - 1; i++) {
      polygons.add(
        Polygon(
          polygonId: PolygonId('${markers[i].markerId.value}'),
          points: [markers[i].position, markers[i + 1].position],
          strokeWidth: 2,
        ),
      );
    }
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


}