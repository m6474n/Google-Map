import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/controllers/chatController.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title:const Text('Chat Screen'),
            ),
            body: Center(
                child: ElevatedButton(
              onPressed: () {
                controller.chatController.clear();
                controller.showPopUp(context);

              },
              child:const Text('send Notification'),
            )),

          );
        });
  }
}
