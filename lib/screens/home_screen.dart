


import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/screens/profile_screen.dart';
import 'package:chattingapp/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list =[];
   // for storing searched items
  final List<ChatUser> _searchList=[];
   // for storing search status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
    Apis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((handler){
      // log('Message ${handler}');
      if(handler.toString().contains('resume')) {
        Apis.updateActiveStatus(true);
      }
      if(handler.toString().contains('pause')) {
        Apis.updateActiveStatus(false);
      }
     return Future.value(handler);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_,_){
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
            return;
            }
             // some delay before pop
          Future.delayed(
              const Duration(milliseconds: 300), SystemNavigator.pop);
        },
        child: Scaffold(
          appBar: AppBar(
            leading:  IconButton(onPressed: (){
            setState(() {
              
            });
          }, icon: Icon(Icons.home)),
            title:  _isSearching
                    ? TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Name, Email, ...',hintStyle: TextStyle(color: Colors.white)),
                            autofocus: true,
                            style: TextStyle(color: Colors.white,fontSize: 18,letterSpacing: 1),
                            //when search text changes then updated search list
                            onChanged: (val) {
                            _searchList.clear();
                             for (var i in _list) {
                            if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                                i.email.toLowerCase().contains(val.toLowerCase())) {
                              _searchList.add(i);
                            }
                            setState(() {
                              _searchList;
                            });
                          }
                            },
                            ):Text("Talkzi"),
            actions: <Widget>[
              IconButton(tooltip: 'Search',
                      onPressed: () => setState(() => _isSearching = !_isSearching),
                      icon: Icon(_isSearching
                          ? CupertinoIcons.clear_circled_solid
                          : CupertinoIcons.search)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user:Apis.me)));
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
          stream: Apis.getAllUsers(),
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
             _list=data?.map((e)=>ChatUser.fromJson(e.data())).toList() ?? [];
             if(_list.isNotEmpty){
              return ListView.builder(
            itemCount:_isSearching ? _searchList.length: _list.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,index){
            return  ChatUsercards(user:_isSearching? _searchList[index]: _list[index],);
            // return Text("Name: ${list[index]}");
           }
           );
             }else{
              return Center(child: Text('No connection found!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, color: Colors.blue.shade300),));
             }
            }
        
            
           },
         ),
         ),
      ),
    );
  }
}