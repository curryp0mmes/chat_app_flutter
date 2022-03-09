import 'package:chat_app/app_theme.dart';
import 'package:chat_app/custom_widgets/chatblob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({Key? key}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {

  final _messages = {"test", "hallo", "abc", "hallowelt", "abc1", "hallowelt2", "abc3", "hallowelt4", "abc5", "hallowelt6", "abc7", "Dies ist eine sehr lange Nachricht, damit man auch mal sieht was damit passiert. Hier sind alle Nachkommastellen von PI die ich kenne: 3,14159265358979323846", "abc9", "hallowelt00", "abc11", "hallowelt22"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Chats",style: TextStyle(color: Colors.black)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {Navigator.pop(context);},),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black,))
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                reverse: true,
                  itemCount: _messages.length * 2,
                  itemBuilder: (context, index) {
                    if(index.isOdd) return Padding(padding: EdgeInsets.only(top: 8));

                    final trueIndex = _messages.length - 1 - (index ~/ 2);
                    return ChatblobWidget(message: _messages.elementAt(trueIndex), timestamp: trueIndex.toString()+":07", right: (trueIndex % 3) != 0,); //TODO fix right check and timestamp
                  }
              ),
            ),
          ),
          Container(color: Colors.grey, height: 80, padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Expanded(child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: "Message",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )),
                IconButton(onPressed: (){}, icon: const Icon(Icons.send, color: Colors.white,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
