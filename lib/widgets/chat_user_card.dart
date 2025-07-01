import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:flutter/material.dart';

class ChatUsercards extends StatefulWidget {
  final ChatUser user;
  const ChatUsercards({super.key, required this.user});

  @override
  State<ChatUsercards> createState() => _ChatUsercardsState();
}

class _ChatUsercardsState extends State<ChatUsercards> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child:InkWell(
        onTap:(){} ,
       child: ListTile(
      // leading:CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
      leading:ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(mq.height * .3),
        child: CachedNetworkImage(
          width: mq.height * .055,
          height: mq.height * .055,
          imageUrl:widget.user.image,
          // placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
             ),
      ),
       title: Text(widget.user.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
       subtitle: Text(widget.user.about,maxLines: 1,),
      //  trailing: Text("7:10 pm",style: TextStyle(color: Colors.black54),),
       trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade400, 
          borderRadius: BorderRadius.circular(7)
        ),
       )
       ), 
      ),
      );
  }
}