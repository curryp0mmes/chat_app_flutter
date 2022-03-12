import 'dart:io';

import 'package:chat_app/constants.dart';
import 'package:chat_app/custom_widgets/draggable_card.dart';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipingArea extends StatefulWidget {
  const SwipingArea({Key? key}) : super(key: key);

  @override
  State<SwipingArea> createState() => _SwipingAreaState();
}

class _SwipingAreaState extends State<SwipingArea> {

  List<CardData> peopleDataList = [CardData(picture: FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: Constants.emptyProfilePic).image)];
  int _peopleIndex = 0;
  @override
  void initState() {
    buildInitialList();
    super.initState();
  }

  void buildInitialList() async {
    for(int i = 0; i < 3; i++) {
      await generateRealUser();
      setState(() {
        if(i==0) {
          peopleDataList.removeAt(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;


    return SizedBox(height:  _deviceWidth, width: _deviceWidth,
      child: DraggableCard(
          personData: peopleDataList[_peopleIndex % peopleDataList.length],
          nextPersonData: peopleDataList[(_peopleIndex + 1) % peopleDataList.length],
          onLike: () {setState(() {
            print("Like");
            _peopleIndex+=1;
            if(_peopleIndex >= peopleDataList.length - 2) generateRealUser();
          });},
          onDislike: () {setState(() {
            print("Dislike");
            _peopleIndex+=1;
            if(_peopleIndex >= peopleDataList.length - 2) generateRealUser();
          });}
      ),
    );
  }

  Future<void> generateRealUser() async {
    User? currentUser = AuthenticationTools.getUser();
    UserData randomUser = await DatabaseHandler.getRandomUser(excludedUIDs: [currentUser?.uid ?? "anon"]);

    var picture = FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: randomUser.photoURL ?? Constants.emptyProfilePic);
    peopleDataList.add(CardData(picture: picture.image, name: randomUser.displayName));
    return;
  }
}
