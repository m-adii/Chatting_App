import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message.dart';
import 'package:chattingapp/widgets/message_card.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: const Color.fromARGB(255, 227, 242, 255),
        body: Column(
          children: [
            
            _chatting(),
            _chatInput()],
        ),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: () {
        
      },
      child: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back,color: Colors.white,)),
          ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .045,
            height: mq.height * .045,
            imageUrl:widget.user.image,
         
            errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
               ),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)),
            Text("Last seen not awailable",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12)),
          ],
        )
        ],
      ),
    );
  }
  Widget _chatting(){
    return Expanded(
      child: StreamBuilder(
            // stream: Apis.getAllUsers(),
             builder: (context, snapshot) {
              switch(snapshot.connectionState){
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                // return const Center(child: CircularProgressIndicator());
                //is some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                
              //   final data = snapshot.data?.docs;
              //  _list=data?.map((e)=>ChatUser.fromJson(e.data())).toList() ?? [];
              _list.clear();
               _list.add(Message(toId: 'xyz', msg: 'hii', read: '12:00 AM', type: Type.text, fromId: Apis.user.uid, sent: ''));
               _list.add(Message(toId: Apis.user.uid, msg: 'hello', read: '', type: Type.text, fromId: 'xyz', sent: '12:00 AM'));
               if(_list.isNotEmpty){
                return ListView.builder(
              itemCount:_list.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context,index){
              return MessageCard(message: _list[index],);
             }
             );
               }else{
                return Center(child: Text('Say Hii! 👋',style: TextStyle(fontSize: 20,color: Colors.blue.shade100),));
               }
              }
          
              
             }, stream: null,
           ),
    );
  }
  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01,horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    }, 
                    icon: Icon(Icons.emoji_emotions,color: Colors.blue,)),
                  Expanded(child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Something..",hintStyle: TextStyle(color: Colors.blue.shade300,fontSize: 15),
                      border: InputBorder.none
                    ),
                  )),
                  IconButton(onPressed: (){
                    }, 
                    icon: Icon(Icons.image,color: Colors.blue,size: 28)),
                  IconButton(onPressed: (){
                    }, 
                    icon: Icon(Icons.camera_alt,color: Colors.blue,size: 28,)),
                    SizedBox(width: 5,)
                ],
              ),
            ),
          ),
          MaterialButton(onPressed: (){},
          minWidth: 0,
          padding: EdgeInsets.only(bottom: 10,top: 10,left: 10,right: 5),
          shape: CircleBorder(),
          color: Colors.blue,
          child: Icon(Icons.send,color: Colors.white,size: 26))
        ],
      ),
    );
  }
}