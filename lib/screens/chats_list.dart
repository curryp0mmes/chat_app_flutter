import 'package:mkship_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if(index < 4) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChatWindow(),)
              );
            },
            title: const Text("Dummychat"),
            leading: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/profile${index+1}.jpg'), fit: BoxFit.cover),
                ),
                width: MediaQuery.of(context).size.width / 7, height: MediaQuery.of(context).size.width / 7,
                child: TextButton(onPressed: () {
                  showBigImageAsDialog(context, AssetImage('assets/profile${index+1}.jpg'));
                }, child: Container(),)
              ),
            )
          ); // Image(image: AssetImage('assets/profile1.jpg')),
          }
        return const ListTile(title: Text("Test"),);
      },
    );
  }

  void showBigImageAsDialog(BuildContext context, image) {
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
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                    color: Colors.black26,
                  ),
                  height: MediaQuery.of(context).size.width * 0.8 * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(child: const Text("Namegoeshere", style: TextStyle(fontSize: 20.0, color: Colors.white,decoration: TextDecoration.none),))
                ),
                Spacer(),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(image: image, fit: BoxFit.cover),
              color: Colors.white,
              borderRadius: BorderRadius.circular(40)
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
