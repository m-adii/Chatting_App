import 'dart:developer';

import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message.dart';
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
  // for add a chat user for our conversation
   static Future<bool> addChatUser(String email)async{
    final data = await firestore
    .collection('users')
    .where('email' , isEqualTo: email)
    .get();
    log('data : ${data.docs}');
  if(data.docs.isNotEmpty && data.docs.first.id != user.uid){
    log('user exist:${data.docs.first.data()} ');
     firestore
    .collection('users')
    .doc(user.uid)
    .collection('my_users')
    .doc(data.docs.first.id)
    .set({});
    return true;
  }
  else{
    return false;
  }
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
  //for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId(){
    return firestore
    .collection('users')
    .doc(user.uid)
    .collection('my_users')
    .snapshots();
  }
  //for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String>userIds){
    return firestore
    .collection('users')
    .where('id',whereIn: userIds.isEmpty ? [''] : userIds)
    .snapshots();
  }
  //for updating user information
    static Future<void> sendFirstMessage(ChatUser chatUser,String msg)async{
    await firestore
    .collection('users')
    .doc(chatUser.id).collection('my_users')
    .doc(user.uid)
    .set({})
    .then((value){
     sendMessage(chatUser, msg);
    });
  }
  //for updating user information
    static Future<void> updateUserInfo()async{
    await firestore
    .collection('users')
    .doc(user.uid)
    .update({
      'name':me.name,
      'about ':me.about
    });
  }
  //for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo( ChatUser chatUser)  {
    return firestore
    .collection('users')
    .where('id',isEqualTo: chatUser.id)
    .snapshots();
  }
  //update online or last seen
  static Future<void> updateActiveStatus(bool isOnline)async{
    firestore
    .collection('users')
    .doc(user.uid)
    .update({'is_online': isOnline,'last_active':DateTime
    .now().millisecondsSinceEpoch
    .toString()});
  }
   ///**************chat screen related apis***********///
   
   //chat (collection) --> conversation id (doc) --> (collection) --> message(doc)

  //useful for getting coversation id

   static String getConversationID(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';
 
  //for getting all messages of a spesific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user){
    return firestore
    .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent', descending: true)
    .snapshots();
  }
 //for sending  messages

 static Future<void> sendMessage(ChatUser chatUser,String msg ) async{
  // message sending time
 final time = DateTime.now().millisecondsSinceEpoch.toString();
 //message to send
 final Message message= Message(toId: chatUser.id, msg: msg, read: '', type: Type.text, fromId: user.uid, sent: time);
 final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
 await ref.doc(time).set(message.toJson());

 }
  //update read status of message
  static Future<void>updateMessageReadStatus(Message message)async{
    firestore
    .collection('chats/${getConversationID(message.fromId)}/messages/')
    .doc(message.sent)
    .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }
  //get only last message of the specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user){
    return firestore
    .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy('sent', descending: true)
    .limit(1)
    .snapshots();
  }
  //delete message
  static Future<void> deleteMessage(Message message)async{
  await firestore
    .collection('chats/${getConversationID(message.toId)}/messages/')
    .doc(message.sent)
    .delete();
  }
  //update message
  static Future<void> updateMessage(Message message, String updatedMsg)async{
  await firestore
    .collection('chats/${getConversationID(message.toId)}/messages/')
    .doc(message.sent)
    .update({'msg':updatedMsg});
  }
}