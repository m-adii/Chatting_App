import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';
class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.user});
 final ChatUser user;
  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
          content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              Positioned(
                left: mq.width * .04,
                top: mq.height * .01,
                width: mq.width * .55,
                child: Text(widget.user.name,
                    style: const TextStyle(
                        fontSize: 18,color: Colors.blue, fontWeight: FontWeight.w500)),
              ),
              Positioned(
                top: mq.height * .06,
                left: mq.width * .08,
                child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.height * .25,
                  
                  fit: BoxFit.cover,
                  imageUrl:widget.user.image,
                         
                  errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
                     ),
                        ),
              ),
               Positioned(
                  right: 8,
                  top: 1,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewProfileScreen(user: widget.user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ]
              ),
          
          )
          );
  }
}