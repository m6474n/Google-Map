import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_map/services/background_services.dart';
import 'package:location/location.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_map/controllers/MapController.dart';
import 'package:google_map/views/HomePage.dart';
import 'package:google_map/views/ProfileScreens/ProfileScreen.dart';
import 'package:google_map/views/SplashScreen.dart';
import 'package:google_map/views/auth/loginScreen.dart';
import 'package:google_map/views/googleMap/MapScreen.dart';
import 'package:google_map/views/testScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Location location = Location();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await initService();
  services.service.invoke("stopServices");
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  runApp(const MyApp());
}

BackgroundServices services = BackgroundServices();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestScreen(),
    );
  }
}
