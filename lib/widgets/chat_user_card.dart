import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/my_date_util.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message.dart';
import 'package:chattingapp/screens/chat_screen.dart';
import 'package:chattingapp/widgets/dialogs/profile_dialog.dart';
import 'package:flutter/material.dart';

class ChatUsercards extends StatefulWidget {
  final ChatUser user;
  const ChatUsercards({super.key, required this.user});

  @override
  State<ChatUsercards> createState() => _ChatUsercardsState();
}

class _ChatUsercardsState extends State<ChatUsercards> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child:InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user,)));
        } ,
       child:StreamBuilder(
        stream: Apis.getLastMessage(widget.user), 
        builder: (context,snapshot){

        final data = snapshot.data?.docs;
        final list=data?.map((e)=>Message.fromJson(e.data())).toList() ?? [];
               
             if(list.isNotEmpty){
              _message = list[0];
             }

          return  ListTile(
      leading:InkWell(
        onTap: (){
          showDialog(context: context, builder: (_)=>
          ProfileDialog(user: widget.user,)
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .055,
            height: mq.height * .055,
            imageUrl:widget.user.image,
         
            errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
               ),
        ),
      ),
       title: Text(widget.user.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
       subtitle: Text(_message != null ? _message!.msg : widget.user.about,maxLines: 1,),
    
       trailing: _message == null ? null: _message!.read.isEmpty && _message!.fromId != Apis.user.uid ? 
       Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade400, 
          borderRadius: BorderRadius.circular(7)
        ),
       ):
       Text(
        MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
       style: TextStyle(color: Colors.black54),)
       );
        }
        )
      ),
      );
  }
} 