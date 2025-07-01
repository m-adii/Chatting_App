import 'package:chattingapp/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  //for accessing firbase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  
  //for accesssing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for storing self info
  static late ChatUser me;
  //to return current user
  static User get user => auth.currentUser!;
  //for checking if user exist or not
  static Future<bool> userExists()async{
    return (await firestore
    .collection('users')
    .doc(user.uid)
    .get())
  .exists;
  }
 // for getting self info
 static Future<void> getSelfInfo()async{
  await firestore.collection('users').doc(user.uid).get().then((user) async {
   if(user.exists){
   me= ChatUser.fromJson(user.data()!);
   }else{
    await createUser().then((value)=>getSelfInfo());
   }
  });
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
  //for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }
}