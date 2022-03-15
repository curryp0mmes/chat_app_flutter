import 'package:mkship_app/constants.dart';
import 'package:mkship_app/firebase/authentication.dart';
import 'package:mkship_app/firebase/database.dart';
import 'package:mkship_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  static List<String> chatIDList = List.empty(growable: true);
  static List<Map<String, dynamic>> chatList = List.empty(growable: true);

  static void buildChatList() async {

    var currentUser = AuthenticationTools.getUser();

    chatIDList = await DatabaseHandler.getUserChats(uid: currentUser?.uid);

    for(int i = 0; i < 10 && i < chatIDList.length; i++) {
      while(chatList.length < i + 1) {
        chatList.add(<String,dynamic>{});
      }
      chatList[i] = await DatabaseHandler.getChatInfo(chatIDList[i]);
    }
  }

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    if(ChatList.chatList.isEmpty) {
      ChatList.buildChatList();
      return const Center(child:Text("You have no chats yet"));
    }
    return ListView.builder(
      itemCount: ChatList.chatIDList.length,
      itemBuilder: (context, index) {
        FadeInImage picture = FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: Constants.emptyProfilePic);
        String chatName = "Error loading values";
        if(ChatList.chatList.length > index) {
          Map<String, dynamic> chatValues = ChatList.chatList[index];

          if(chatValues["chatName"] != null) {
            chatName = chatValues["chatName"];
          }
          else {
            if(chatValues["members"] != null) {
              List<Map<String, dynamic>> members = (chatValues["members"] as List<dynamic>).cast();

              chatName = "";
              bool skipFirst = true;
              for(var member in members) {
                if (member["uid"] == AuthenticationTools.getUser()?.uid) continue;
                if(!skipFirst) {
                  chatName += ", ";
                }
                skipFirst = false;
                chatName += member["displayName"];
                picture = FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: member["photoURL"] ?? Constants.emptyProfilePic);
              }
            }
          }
        }
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatWindow(chatID: ChatList.chatIDList[index], chatName: chatName),)
            );
          },
          title: Text(chatName),
          leading: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: picture.image, fit: BoxFit.cover),
                  ),
                  child: TextButton(onPressed: () {
                    showBigImageAsDialog(context: context, image: picture, name: chatName);
                  }, child: Container(),)
                ),
              ),
            ),
          )
        ); // Image(image: AssetImage('assets/profile1.jpg')),
      },
    );
  }

  void showBigImageAsDialog({required BuildContext context, required FadeInImage image, String? name}) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, animation2) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(
              children: [
                image,
                name==null ? Container() : Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                      ),
                      child: Center(child: Text(name, style: const TextStyle(fontSize: 20.0, color: Colors.white,decoration: TextDecoration.none),))
                    ),
                  ),
                  Spacer(flex: 8),
                ],
                ),
              ]
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }
}
