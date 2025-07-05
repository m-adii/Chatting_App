import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/my_date_util.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message.dart';
import 'package:chattingapp/screens/view_profile_screen.dart';
import 'package:chattingapp/widgets/message_card.dart';
import 'package:flutter_emoji_picker/flutter_emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();

   bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: PopScope(
         canPop: false,
          onPopInvokedWithResult: (_, __) {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return;
          }
        Future.delayed(const Duration(milliseconds: 300), () {
            try {
              if (Navigator.canPop(context)) Navigator.pop(context);
            } catch (e) {
              log('ErrorPop: $e');
            }
          });
        },

        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          backgroundColor: const Color.fromARGB(255, 227, 242, 255),
          body: Column(
            children: [
              
              _chatting(),
              _chatInput(),
              
              // if (_showEmoji)
  // SizedBox(
  //   height: mq.height * 0.3,
  //   child: FlutterEmojiPicker(
  //     onEmojiSelected: (emoji) {
  //       _textController.text += emoji;
  //       _textController.selection = TextSelection.fromPosition(
  //         TextPosition(offset: _textController.text.length),
  //       );
  //     },
  //   ),
  // ),
              ],
          ),
        ),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: Apis.getUserInfo(widget.user),builder: (context, snapshot) {
            final data = snapshot.data?.docs;
        final list=data?.map((e)=>ChatUser.fromJson(e.data())).toList() ?? [];
               
          return Row(
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)),
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
                Text(list.isNotEmpty ? list[0].name:widget.user.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)),
                Text(list.isNotEmpty? 
                list[0].isOnline? 'Online'
                : MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                :MyDateUtil.getLastActiveTime(context: context, lastActive:widget.user.lastActive),
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12)),
              ],
            )
            ],
          );
          },
        ),
      ),
    );
  }
  Widget _chatting(){
    return Expanded(
      child: StreamBuilder(
            stream: Apis.getAllMessages(widget.user),
             builder: (context, snapshot) {
              switch(snapshot.connectionState){
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                return const SizedBox();
                //is some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                
               final data = snapshot.data?.docs;
               
              _list=data?.map((e)=>Message.fromJson(e.data())).toList() ?? [];
               if(_list.isNotEmpty){
                return ListView.builder(
                  reverse: true,
              itemCount:_list.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context,index){
              return MessageCard(message: _list[index],);
             }
             );
               }else{
                return Center(child: Text('Say Hii! 👋',style: TextStyle(fontSize: 20,color: Colors.blue.shade300),));
               }
              }
          
              
             }, 
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
                  EmojiButton(
                  emojiPickerViewConfiguration: EmojiPickerViewConfiguration(
                    viewType: ViewType.dialog,
                    onEmojiSelected: (emoji) {
                      _textController.text += emoji;
                      _textController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: _textController.text.length),
                      );
                    },
                  ),
                  child: const Icon(Icons.emoji_emotions, color: Colors.blue),
                ),
                  Expanded(child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      // if(_showEmoji) {
                      //   setState(()=>_showEmoji =!_showEmoji);
                      // }
                    },
                    decoration: InputDecoration(
                      hintText: "Type Something..",hintStyle: TextStyle(color: Colors.blue.shade300,fontSize: 15),
                      border: InputBorder.none
                    ),
                  )),
                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if(image !=null){
                      // log('Image path: ${image.path}');
                      setState(() {
                      });
                      //for hiding bottom sheet
                      Navigator.pop(context);
                    }
                    }, 
                    icon: Icon(Icons.image,color: Colors.blue,size: 28)),
                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if(image !=null){
                      // log('Image path: ${image.path}');
                      setState(() {
                      });
                      //for hiding bottom sheet
                      Navigator.pop(context);
                    }
                    }, 
                    icon: Icon(Icons.camera_alt,color: Colors.blue,size: 28,)),
                    SizedBox(width: 5,)
                ],
              ),
            ),
          ),
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              Apis.sendMessage(widget.user, _textController.text);
              _textController.text='';
            }
          },
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