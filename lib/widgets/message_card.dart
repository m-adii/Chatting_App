import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/dialogs.dart';
import 'package:chattingapp/helper/my_date_util.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message,});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: (){
      _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage():_blueMessage() );
     
  }
  //sender messages
  Widget _blueMessage(){
    if(widget.message.read.isEmpty){
      Apis.updateMessageReadStatus(widget.message);
    }
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
            child: Text(widget.message.msg,
            style: TextStyle(color: Colors.black87,fontSize: 16),),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .08),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
          style: TextStyle(color: Colors.black54,fontSize: 12),),
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
            if(widget.message.read.isNotEmpty)
            const Icon(Icons.done_all_rounded,color: Colors.blue,size: 22,),
            SizedBox(width: mq.width * .01),
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(color: Colors.black54,fontSize: 12),),
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
    // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),

              
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: (ctx) async {
                         await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          if (ctx.mounted) {
                            //for hiding bottom sheet
                            Navigator.pop(ctx);

                            Dialogs.showSnackbar(ctx, 'Text Copied!');
                          }
                        });
                      }),
                  
                  

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black12,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: (ctx) {
                      if (ctx.mounted) {
                        _showMessageUpdateDialog(ctx);

                        //for hiding bottom sheet
                        // Navigator.pop(ctx);
                      }
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: (ctx) async {
                      await Apis.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        if (ctx.mounted) Navigator.pop(ctx);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black12,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime( context: context, time: widget.message.sent)}',
                  onTap: (_) {},),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: (_) {},),
            ],
          );
        });
  }
  //dialog for updating message content
  void _showMessageUpdateDialog(final BuildContext ctx) {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      Apis.updateMessage(widget.message, updatedMsg);
                      //hide alert dialog
                      Navigator.pop(ctx);

                      //for hiding bottom sheet
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}


class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final Function(BuildContext) onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(context),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .02),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}