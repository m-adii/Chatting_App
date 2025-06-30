import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  //for accessing firbase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accesssing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}