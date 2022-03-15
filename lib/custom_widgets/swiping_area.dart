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

  @override
  Widget build(BuildContext context) {
    var _swipingCardWidth = MediaQuery.of(context).size.width - Constants.edgePadding * 2;

    return SizedBox(height:  _swipingCardWidth, width: _swipingCardWidth,
      child: Stack(
        children: [
          ProfileSwipingCard(personData: peopleDataList[(_peopleIndex + 2) % peopleDataList.length], elevation: 12,), //back most element draws the elevation
          ProfileSwipingCard(personData: peopleDataList[(_peopleIndex + 1) % peopleDataList.length], elevation: 0,),
          DraggableCard(
            personData: peopleDataList[_peopleIndex % peopleDataList.length],
            onLike: () {
              setState(() {
                print("Like");
                generateRealUser();
              });
            },
            onDislike: () {
              setState(() {
                print("Dislike");
                generateRealUser();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> generateRealUser() async {
    User? currentUser = AuthenticationTools.getUser();

    while(_peopleIndex > peopleDataList.length - 3) {
      UserData randomUser = await DatabaseHandler.getRandomUser(excludedUIDs: [currentUser?.uid ?? "anon"]);
      var picture = FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: randomUser.photoURL ?? Constants.emptyProfilePic, fadeInDuration: const Duration(milliseconds: 10), fadeOutDuration: const Duration(milliseconds: 10),);
      peopleDataList.add(
          CardData(picture: picture, name: randomUser.displayName)
      );
    }
    _peopleIndex += 1;
    return;
  }

  void buildInitialList() async {
    await generateRealUser();
    setState(() {
      peopleDataList.removeAt(0);
    });
  }
}
