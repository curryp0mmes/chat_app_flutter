import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mkship_app/app_theme.dart';
import 'package:mkship_app/custom_widgets/chatblob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkship_app/firebase/authentication.dart';
import 'package:mkship_app/firebase/database.dart';

class ChatWindow extends StatefulWidget {
  final String chatID;
  final String chatName;

  const ChatWindow({Key? key, required this.chatID, required this.chatName}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String get chatID => widget.chatID;
  String get chatName => widget.chatName;

  final _messages = {"test", "hallo", "abc", "hallowelt", "abc1", "hallowelt2", "abc3", "hallowelt4", "abc5", "hallowelt6", "abc7", "Dies ist eine sehr lange Nachricht, damit man auch mal sieht was damit passiert. Hier sind alle Nachkommastellen von PI die ich kenne: 3,14159265358979323846", "abc9", "hallowelt00", "abc11", "hallowelt22"};

  final TextEditingController _newMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(chatName,style: const TextStyle(color: Colors.black)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black,))
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseHandler.getLiveChatMessages(chatID),
              builder:(context, snapshot) {
                if(!snapshot.hasData) return const Text("Loading");
                return ListView.builder(
                    reverse: true,
                    itemCount: (snapshot.data?.docs.length??0) * 2 + 1,
                    itemBuilder: (context, index) {
                      if(index.isEven) return const Padding(padding: EdgeInsets.only(top: 8));

                      final trueIndex = (snapshot.data?.docs.length??0) - 1 - (index ~/ 2);
                      var messageData = snapshot.data?.docs[trueIndex];

                      String timestamp;
                      try {
                        Timestamp ts = messageData?.get("timestamp");

                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final yesterday = DateTime(now.year, now.month, now.day - 1);

                        final dateCheck = DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);
                        timestamp = '${dateCheck == yesterday? "Gestern,   ":dateCheck==today?"":'${dateCheck.day}.${dateCheck.month}.${dateCheck.year}   '}${ts.toDate().toLocal().hour}:${ts.toDate().toLocal().minute}';
                      } on StateError {
                        timestamp = "--:--";
                      }
                      String messageText;
                      try {
                        messageText = messageData?.get("messageText");
                      } on StateError {
                        messageText = "";
                      }
                      bool displayRight = false;
                      try {
                        String senderUID = messageData?.get("from");
                        if(senderUID == AuthenticationTools.getUser()?.uid) displayRight = true;
                      } on StateError {
                        displayRight = false;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ChatblobWidget(message: messageText, timestamp: timestamp, right: displayRight),
                      ); //TODO fix right check and timestamp
                    }
                );
              },
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
                        DatabaseHandler.sendChatMessage(chatID, message);
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
