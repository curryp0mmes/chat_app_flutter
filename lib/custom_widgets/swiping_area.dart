import 'dart:io';

import 'package:mkship_app/constants.dart';
import 'package:mkship_app/custom_widgets/draggable_card.dart';
import 'package:mkship_app/firebase/authentication.dart';
import 'package:mkship_app/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipingArea extends StatefulWidget {
  const SwipingArea({Key? key}) : super(key: key);

  @override
  State<SwipingArea> createState() => _SwipingAreaState();
}

class _SwipingAreaState extends State<SwipingArea> {

  List<CardData> peopleDataList = [CardData(picture: Image(image: AssetImage(Constants.emptyProfilePicAsset)))];
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
    var _swipingCardWidth = MediaQuery.of(context).size.width - Constants.edgePadding * 2;


    return SizedBox(height:  _swipingCardWidth, width: _swipingCardWidth,
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

    var picture = FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: randomUser.photoURL ?? Constants.emptyProfilePic, fadeInDuration: Duration(milliseconds: 10), fadeOutDuration: Duration(milliseconds: 10),);
    peopleDataList.add(CardData(picture: picture, name: randomUser.displayName));
    return;
  }
}
