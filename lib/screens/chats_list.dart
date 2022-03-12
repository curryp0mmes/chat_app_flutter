import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      if(index == 0) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new ChatWindow(),)
            );
          },
          title: const Text("Dummychat"),
          leading: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/profile1.jpg'), fit: BoxFit.cover),
              ),
              width: MediaQuery.of(context).size.width / 7, height: MediaQuery.of(context).size.width / 7,
              child: TextButton(onPressed: () {}, child: Text(""),)
            ),
          )
        ); // Image(image: AssetImage('assets/profile1.jpg')),
      }
      return const ListTile(title: Text("Test"),);
      },
    );
  }
}
