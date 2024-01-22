import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/controllers/Auth_controller.dart';

class EmailField extends StatelessWidget {
  final String lable;

  final TextEditingController controller;
  final IconData prefixIcon;

  EmailField(
      {super.key,
        required this.lable,

        required this.controller,
        required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,

        decoration: InputDecoration(
            hintText: lable,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.deepPurple,
            ),

            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
