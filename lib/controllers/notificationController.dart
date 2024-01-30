import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_map/services/NotificationService.dart';

class NotificationController extends GetxController{

  NotificationService service = NotificationService();
  final storage = FirebaseFirestore.instance;
@override
  void onInit() {
    // TODO: implement onInit
  service.requestNotification();
  service.getToken();
  service.isTokenRefreshed();
  service.firebaseInit();
    super.onInit();

}

addTokenToFirebase(){
 service.getToken().then((value){
   storage.collection('Devices').doc(FirebaseAuth.instance.currentUser!.uid).set({
     'token':value
   });
 });
 FirebaseMessaging.instance.onTokenRefresh.listen((value) {
     storage.collection('Devices').doc(FirebaseAuth.instance.currentUser!.uid).set({
       'token':value
     });

 });
  update();
}
}