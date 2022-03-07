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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  ChatblobWidget(message: "TestMessage1eahkjsdhkjsakjdhasjkhdjkasjkdh", right: false,),
                  Padding(padding: EdgeInsets.all(2)),
                  ChatblobWidget(message: "TestMessage2",),
                  Padding(padding: EdgeInsets.all(2)),
                  ChatblobWidget(message: "TestMessage3",),
                  Padding(padding: EdgeInsets.all(2)),
                  ChatblobWidget(message: "TestMessage4", right: false,),
                  Padding(padding: EdgeInsets.all(2)),
                  ChatblobWidget(message: "TestMessage5",),
                  Padding(padding: EdgeInsets.all(2)),
                  ChatblobWidget(message: "TestMessage6",),
                ],
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
