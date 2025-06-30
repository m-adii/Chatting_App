// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/dialogs.dart';
import 'package:chattingapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
    setState(() {
      _isAimate= true;
    });
    }
    );
  }
  _handleGoogleBtnClick(){
    //for showing progress bar
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      if(user != null){
          log('\nUser: ${user.user}');
      log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

      if((await Apis.userExists())){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
      else{
       await Apis.createUser().then((value){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
       });
      }
      }
    });
  }
  Future<UserCredential?> _signInWithGoogle() async {
  try{
    await InternetAddress.lookup('google.com');
    // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await Apis.auth.signInWithCredential(credential);
  }
  catch(e){
    log('\n_signInWithGoogle: $e');
    Dialogs.showSnackbar(context, 'Something went wrong(Check internet!)');
    return null;
  }
}
  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
      title: Text("Welcome to TalkZi"),
      ),
      body: (
        Stack(
          children: [
            AnimatedPositioned(
              top: _isAimate ? mq.height * .05 : -mq.height * .4,
              width: mq.width * .8,
              left:mq.width * .10,
              duration: Duration(seconds: 1),
              curve: Curves.bounceOut,
              child: Image.asset('images/icon.png')),
            Positioned(
              bottom: mq.height * .15,
              width: mq.width * .8,
              left: mq.width * .1,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                onPressed: (){
               _handleGoogleBtnClick();
              },
              icon:Image.asset('images/google.png') , label: RichText(text: const TextSpan(
                style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),
                children: [
                  TextSpan(text: "Login with "),
                  TextSpan(text: "google",style: TextStyle(fontWeight: FontWeight.w600))
                ]
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                shape: const StadiumBorder(),
                elevation: 6
              ),
              ))
          ],
        )
      ),
    );
  }
}