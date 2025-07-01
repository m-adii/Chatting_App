
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/screens/profile_screen.dart';
import 'package:chattingapp/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Talkzi"),
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user:list[0])));
          }, icon: const Icon(Icons.more_vert)),
        ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50,right: 10),
          child: FloatingActionButton(
            onPressed: ()async{
              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
            },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.add_comment_rounded,color: Colors.white,),
          ),
        ),
     body: StreamBuilder(
      stream: Apis.firestore.collection('users').snapshots(),
       builder: (context, snapshot) {
        switch(snapshot.connectionState){
          //if data is loading
          case ConnectionState.waiting:
          case ConnectionState.none:
          return const Center(child: CircularProgressIndicator());
          //is some or all data is loaded then show it
          case ConnectionState.active:
          case ConnectionState.done:
          
          final data = snapshot.data?.docs;
         list=data?.map((e)=>ChatUser.fromJson(e.data())).toList() ?? [];
         if(list.isNotEmpty){
          return ListView.builder(
        itemCount: list.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context,index){
        return  ChatUsercards(user: list[index],);
        // return Text("Name: ${list[index]}");
       }
       );
         }else{
          return Center(child: Text('No connection found!',style: TextStyle(fontSize: 20,color: Colors.blue),));
         }
        }

        
       },
     ),
     );
  }
}