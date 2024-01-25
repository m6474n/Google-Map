import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_map/services/splashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashService _service = SplashService();

@override
  void initState() {
    // TODO: implement initState
  _service.isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.asset('assets/marker.png'), Text("Google Map", style: TextStyle(color: Color(
            0xfffc746c), fontSize: 32, fontWeight: FontWeight.bold),)],),
    ),);
  }
}
