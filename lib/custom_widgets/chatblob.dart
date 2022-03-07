import 'package:flutter/material.dart';

class ChatblobWidget extends StatefulWidget {
  final String message;
  final bool right;
  const ChatblobWidget({Key? key, required this.message, this.right = true}) : super(key: key);

  @override
  _ChatblobWidgetState createState() => _ChatblobWidgetState();
}

class _ChatblobWidgetState extends State<ChatblobWidget> {
  String get message => widget.message;
  bool get right => widget.right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 100, maxWidth: 200), //TODO figure out how to shrink the box while keeping maxwidth
          child: Container(
            decoration: const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(10.0))),
            alignment: right ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 9.0, bottom: 10.0),
            child: Text(message,style: const TextStyle(color: Colors.white)),
          ),
        ),
        const Spacer(),
      ].sublist(right ? 0 : 1, right ? 2 : 3),
    );
  }
}
