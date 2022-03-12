import 'package:mkship_app/app_theme.dart';
import 'package:mkship_app/custom_widgets/chatblob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({Key? key}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {

  final _messages = {"test", "hallo", "abc", "hallowelt", "abc1", "hallowelt2", "abc3", "hallowelt4", "abc5", "hallowelt6", "abc7", "Dies ist eine sehr lange Nachricht, damit man auch mal sieht was damit passiert. Hier sind alle Nachkommastellen von PI die ich kenne: 3,14159265358979323846", "abc9", "hallowelt00", "abc11", "hallowelt22"};

  TextEditingController _newMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Chats",style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black,))
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
                itemCount: _messages.length * 2 + 1,
                itemBuilder: (context, index) {
                  if(index.isEven) return Padding(padding: EdgeInsets.only(top: 8));

                  final trueIndex = _messages.length - 1 - (index ~/ 2);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: ChatblobWidget(message: _messages.elementAt(trueIndex), timestamp: trueIndex.toString()+":07", right: (trueIndex % 3) != 0,),
                  ); //TODO fix right check and timestamp
                }
            ),
          ),
          Container(color: Colors.grey, height: 80, padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: "Message",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: _newMessageController,
                )),
                IconButton(
                  onPressed: () {
                    var message = _newMessageController.text;
                    if(message.isNotEmpty) {
                      setState(() {
                        _messages.add(message);
                        _newMessageController.text = "";
                      });
                    }
                  },
                  icon: const Icon(Icons.send, color: Colors.white,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
