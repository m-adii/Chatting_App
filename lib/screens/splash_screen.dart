import 'dart:developer';

import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/screens/auth/login_screen.dart';
import 'package:chattingapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(Duration(milliseconds: 1500), ()async{
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent,statusBarColor: Colors.transparent));
      // ignore: use_build_context_synchronously
      if(Apis.auth.currentUser != null){
            log('\nUser: ${Apis.auth.currentUser}');
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
    }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
    
      body: (
        Stack(
          children: [
           Positioned(
              top: mq.height * .15 ,
              width: mq.width * .9,
              left:mq.width * .05,
              child: Image.asset('images/icon.png')),
            Positioned(
              bottom: mq.height * .10,
              width: mq.width * .8,
              left: mq.width * .1,
              height: mq.height * .06,
              child: Text("MADE BY ADEEL WITH ❤️",
               textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue.shade200,fontWeight: FontWeight.w700),))
          ],
        )
      ),
    );
  }
}