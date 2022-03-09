import 'package:flutter/material.dart';

class ChatblobWidget extends StatefulWidget {
  final String message;
  final String? timestamp;
  final bool right;
  const ChatblobWidget({Key? key, required this.message, this.right = true, this.timestamp}) : super(key: key);

  @override
  _ChatblobWidgetState createState() => _ChatblobWidgetState();
}

class _ChatblobWidgetState extends State<ChatblobWidget> {
  String get message => widget.message;
  bool get right => widget.right;

  String? get timestamp => widget.timestamp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 40, maxWidth: MediaQuery.of(context).size.width * 3 / 5), //TODO figure out how to shrink the box while keeping maxwidth
          child: Container(
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0), bottomLeft: right ? const Radius.circular(10.0) : Radius.zero, bottomRight: !right ? const Radius.circular(10.0) : Radius.zero),
            ),
            //alignment: right ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 9.0, bottom: 4.0),
            child: Column(
              crossAxisAlignment: right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(message,style: const TextStyle(color: Colors.white)),
                const Padding(padding: EdgeInsets.all(3.0),),
                Text(timestamp??"",style: const TextStyle(fontSize:10, color: Colors.white70)),
              ],
            ),
          ),
        ),
        const Spacer(),
      ].sublist(right ? 0 : 1, right ? 2 : 3),
    );
  }
}
