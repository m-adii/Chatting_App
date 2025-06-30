import 'package:chattingapp/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  //for accessing firbase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accesssing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;
  //for checking if user exist or not
  static Future<bool> userExists()async{
    return (await firestore
    .collection('users')
    .doc(user.uid)
    .get())
  .exists;
  }

  //for creating a new user
    static Future<void> createUser()async{
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final chatUser = ChatUser(
        image: user.photoURL.toString(),
        createdAt: time, 
        name: user.displayName.toString(), 
        id: user.uid, 
        isOnline: false, 
        lastActive: time, 
        about: "Hey! I am using TalkZi", 
        email: user.email.toString(), 
        pushToken: ''
        );
    return await firestore
    .collection('users')
    .doc(user.uid).set(chatUser.toJson());
    
  }
}