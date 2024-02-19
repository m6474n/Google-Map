import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_map/main.dart';
import 'package:google_map/services/StateManager.dart';
import 'package:google_map/services/background_services.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;
  late bool _isOnline = false;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    services.service.invoke('stopServices');
    super.initState();
  }
BackgroundServices services = BackgroundServices();
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
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        print('Resumed');
        services.service.invoke("stopService");
        break;
      case AppLifecycleState.inactive:
        // --
        print('Inactive');
        break;
      case AppLifecycleState.paused:
        // --
        print('Paused');
        services.initService();
        break;
      case AppLifecycleState.detached:
        // --
        services.initService();
        print('Detached');

        break;
      // case AppLifecycleState.hidden:
      // // A new *hidden* state has been introduced in latest flutter version
      //   print('Hidden');
      //   break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie.network(
            //     'https://lottie.host/b4d309f0-b49f-40ad-afc4-14f1efbfded9/OxATyFGOct.json'),
            const Text(
              "Ring Bell",
              style: TextStyle(
                  color: Color(0xfffc746c),
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            Text('User is ${_isOnline ? 'Online' : 'Offline'}'),
            ElevatedButton(
                onPressed: () {
                 sendNotification();
                },
                child: Text('Show Notification'))
          ],
        ),
      ),
    );
  }
}
