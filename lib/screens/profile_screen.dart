
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Profile Screen"),
       
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40,right: 10),
          child: FloatingActionButton.extended(
            onPressed: ()async{
              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
            },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(Icons.logout_outlined,color: Colors.white,), 
          label: Text('Logout',style: TextStyle(color: Colors.white),),
          ),
        ),
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
       child: Column(
        children: [
          SizedBox(
            width: mq.width,
            height: mq.height * .07,
          ),
          ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(mq.height * .2),
          child: CachedNetworkImage(
            width: mq.height * .20,
            height: mq.height * .20,
            fit: BoxFit.fill,
            imageUrl:widget.user.image,
         
            errorWidget: (context, url, error) =>CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.person_2_outlined,color: Colors.white,),),
               ),
        ),
        SizedBox(
            height: mq.height * .02,
          ),
          Text(widget.user.email,style:const TextStyle(color: Colors.black54,fontSize: 16),),
                SizedBox(
            height: mq.height * .07,
          ),
          TextFormField(
            initialValue: widget.user.name,
           decoration: InputDecoration( 
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.height * .02),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2
              )
            ),
            label: Text('Name'),
            prefixIcon: Icon(Icons.person,color: Colors.blue,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.height * .02),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2
              )
            )
           ),
          ),
           SizedBox(
            height: mq.height * .03,
          ),
          TextFormField(
            initialValue: widget.user.about,
           decoration: InputDecoration( 
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.height * .02),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2
              )
            ),
            label: Text('About'),
            prefixIcon: Icon(Icons.info_outline,color: Colors.blue,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.height * .02),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2
              )
            )
           ),
          ),
           SizedBox(
            height: mq.height * .05,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(mq.width *.5, mq.height * .07),
              backgroundColor: Colors.blue
            ),
            onPressed: (){}, 
            label: Text('Update',style: TextStyle(color: Colors.white,fontSize: 18),),
            icon: Icon(Icons.edit,color: Colors.white,size: 25,),
            )
        ],
       ),
     )
     );
  }
}