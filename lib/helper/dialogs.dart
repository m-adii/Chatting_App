import 'package:flutter/material.dart';
class Dialogs {
  static void showSnackbar(BuildContext context, String msg){
    if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Center(child: Text(msg,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),)),
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  )
  );
  }
  static void showProgressbar(BuildContext context){
  showDialog(context: context, builder: (_)=> const Center(child: CircularProgressIndicator()));
  }
}