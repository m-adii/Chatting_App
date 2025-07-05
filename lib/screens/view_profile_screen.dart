


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/helper/my_date_util.dart';

import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //to hide kepboard on tap
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading:  IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios,size: 20,)),
          title: Text(widget.user.name),
         
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),

          
       body: Padding(
         padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
         child: SingleChildScrollView(
           child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .05,
              ),
              ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(mq.height * .2),
              child: CachedNetworkImage(
                width: mq.height * .20,
                height: mq.height * .20,
                fit: BoxFit.cover,
                imageUrl:widget.user.image,
                       
                errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
                   ),
                      ),
            SizedBox(
                height: mq.height * .02,
              ),
              Text(widget.user.email,style:const TextStyle(color: Colors.black54,fontSize: 16),),
                    SizedBox(
                height: mq.height * .06,
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ]
              )
            ],
           ),
         ),
       )
       ),
    );
  }
  // bottom sheet for picking a profile picture for user
  
}