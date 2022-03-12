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

  List<CardData> dummyDataPeople = [
    CardData(picture: const AssetImage('assets/profile1.jpg'), age: 19, name: "Angela"),
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
          personData: dummyDataPeople[_peopleIndex % dummyDataPeople.length],
          nextPersonData: dummyDataPeople[(_peopleIndex + 1) % dummyDataPeople.length],
          onLike: () {setState(() {
            print("Like");
            _peopleIndex+=1;
          });},
          onDislike: () {setState(() {
            print("Dislike");
            _peopleIndex+=1;
          });}
      ),
    );
  }
}
