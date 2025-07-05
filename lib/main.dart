
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji_picker/flutter_emoji_picker.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

late Size mq;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((onValue){
  runApp(EmojiProvider(child: const MyApp()));
});
  }
  

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w500
        ),
        backgroundColor: Colors.blue
      )
      ),
      home: const SplashScreen(),
    );
  }
}

  Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}

