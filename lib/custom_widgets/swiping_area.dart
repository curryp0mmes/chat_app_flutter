import 'dart:io';

import 'package:chat_app/custom_widgets/draggable_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipingArea extends StatefulWidget {
  const SwipingArea({Key? key}) : super(key: key);

  @override
  State<SwipingArea> createState() => _SwipingAreaState();
}

class _SwipingAreaState extends State<SwipingArea> {

  List<CardData> dummypeople = [
    CardData(picture: const AssetImage('assets/profile1.jpg'), age: 19, name: "Adame"),
    CardData(picture: const AssetImage('assets/profile2.jpg'), age: 21, name: "Jonas"),
    CardData(picture: const AssetImage('assets/profile3.jpg'), age: 36, name: "April"),
    CardData(picture: const AssetImage('assets/profile4.jpg'), age: 20, name: "John"),
  ];
  int _peopleIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;


    return SizedBox(height:  _deviceWidth, width: _deviceWidth,
      child: DraggableCard(
          personData: dummypeople[_peopleIndex % dummypeople.length],
          nextPersonData: dummypeople[(_peopleIndex + 1) % dummypeople.length],
          onLike: () {setState(() {
            _peopleIndex+=1;
          });},
          onDislike: () {setState(() {
            _peopleIndex+=1;
          });}
      ),
    );
  }
}
