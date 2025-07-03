import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message,});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromId ? _greenMessage():_blueMessage();
  }
  //sender messages
  Widget _blueMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Flexible(
          child: Container(
           padding: EdgeInsets.symmetric(horizontal: mq.width *.05,vertical: mq.width * .02),
           margin: EdgeInsets.all(mq.height * .02),
           decoration: BoxDecoration(
            color: const Color.fromARGB(255, 216, 238, 255),
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
              )
           ),
            child: Text(widget.message.msg,style: TextStyle(color: Colors.black87,fontSize: 16),),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .08),
          child: Text(widget.message.sent,style: TextStyle(color: Colors.black54,fontSize: 12),),
        ),
      ],
    );
  }
  //user messages
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        
        Row(
          children: [
            SizedBox(width: mq.width * .04),
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 22,),
            SizedBox(width: mq.width * .01),
            Text(widget.message.read,style: TextStyle(color: Colors.black54,fontSize: 12),),
          ],
        ),
        Flexible(
          child: Container(
           padding: EdgeInsets.symmetric(horizontal: mq.width *.05,vertical: mq.width * .02),
           margin: EdgeInsets.all(mq.height * .02),
           decoration: BoxDecoration(
            color: const Color.fromARGB(255, 219, 255, 210),
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)
              )
           ),
            child: Text(widget.message.msg,style: TextStyle(color: Colors.black87,fontSize: 16),),
          ),
        ),
      ],
    );
  }
}