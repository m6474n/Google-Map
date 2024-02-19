import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/main.dart';
import 'package:google_map/services/StateManager.dart';

class BackgroundServices{
  FlutterBackgroundService service = FlutterBackgroundService();


  Future<void> initService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(),
    );
    service.startService();
  }

  int counter = 0;
  String value= " Location";
@pragma("vm:entry-point")
 static onStart(ServiceInstance service) async {
  int counter = 0;

  Future<void> sendNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',

      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alert!',
      'App Close',
      platformChannelSpecifics,
    );
  }
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      String value = "Location";
      if (service is AndroidServiceInstance) {
        // service.setForegroundNotificationInfo(
        //   title: "Background Service",
        //   content: "Update ${value}",
        // );
          // 
          counter ++;
          if(counter == 15){
            sendNotification();
            service.invoke("stopService");
          }
          else{
            print(counter);
          }
        // print(counter++);
        //   StateManager().state == true ? sendNotification() : print('Hi...');
        // getLocation(value);
      }
      // service.invoke(
      //   'update',
      //   {
      //     "current_date": DateTime.now().toIso8601String(),
      //   },
      // );
    });
  }
}

getLocation(String value)async{
  await Geolocator.getPositionStream().listen((event) {
    value = "${event.latitude}, ${event.longitude}";
    print(event.toString());});
}