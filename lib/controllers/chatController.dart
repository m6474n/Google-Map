import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/CutomInputField.dart';
import 'package:google_map/services/NotificationService.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  NotificationService notify = NotificationService();
  final chatController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
final tokenStream = FirebaseFirestore.instance.collection('Devices').snapshots();
  sendNotification() async {

notify.getToken().then((value)async{
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Devices').get();
  snapshot.docs.forEach((doc) async{
    String val =  doc['token'];
    var data = {
      'to': value == val.toString()? '': val.toString(),
      'priority': 'high',
      'notification': {
        'title': user!.displayName.toString(),
        'body': chatController.text.toString()
      }

    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'key=AAAAubZCUDQ:APA91bF-91J8-5pvykjOao6nAC-MeBLSMDV5BwCNMePMGsTVG-D3BQaZvabBVVzIpJc-NrFjvtEhfE8BG3V_bGzKcW5ZYTZTAkb_Y8OHDRQte9LcV6rkS1l_0sEJyk7gOGsSNoj77MMt'
        });

  });
});


  }

  showPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Send Message'),
            content: CustomInput(
              controller: chatController,
              label: 'Type anything',
              prefixIcon: Icons.keyboard,
              ontap: () {},
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                      onPressed: () {
                        sendNotification();
                        Get.back();


                      },
                      child: Text('send')),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('cancel'),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)))))
                ],
              )
            ],
          );
        });
  }
}
