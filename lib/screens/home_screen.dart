import 'dart:io';

import 'package:mkship_app/constants.dart';
import 'package:mkship_app/custom_widgets/swiping_area.dart';
import 'package:mkship_app/firebase/authentication.dart';
import 'package:mkship_app/firebase/database.dart';
import 'package:mkship_app/firebase/storage_repo.dart';
import 'package:mkship_app/screens/chat_screen.dart';
import 'package:mkship_app/screens/chats_list.dart';
import 'package:mkship_app/screens/profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

import '../main.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedScreen = 0;



  @override
  Widget build(BuildContext context) {
    final UserData? _currentUser = DatabaseHandler.currentUser;
    return Scaffold (
      appBar: AppBar(
        title: const Text("mk:ship"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,

        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: const Text("Profile"), onTap: () => Future(
                  () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              ),
            )
            ),
            PopupMenuItem(child: const Text("Logout"), onTap: () {
              setState(() {
                AuthenticationTools.logout();
              });
              }
            ),
          ],
            icon: ClipOval(child: FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: _currentUser?.photoURL ?? Constants.emptyProfilePic),),
          )
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
        ],
        onTap: (index){
          setState(() {
            if(index == 1) {
              showSearch(context: context, delegate: CustomSearchDelegate(),);
            } else{
              _selectedScreen = index;
            }
          });
        },
        currentIndex: _selectedScreen,
      ),
      body: _selectedScreen == 2 ? const ChatList() : Padding(
        padding: EdgeInsets.only(top: Constants.edgePadding, right: Constants.edgePadding, left: Constants.edgePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SwipingArea(),
          ],
        ),
      ),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  Future<List<UserData>> allUsers = DatabaseHandler.getAllUsers();
  List<String> searchTerms = List<String>.empty(growable: true);

  void updateSearchList() async {
    allUsers.then(
            (allUsers) {
              searchTerms = List<String>.empty(growable: true);
              for (var userData in allUsers) {
                  if (userData.displayName != null) {
                    searchTerms.add(userData.displayName!);
                  }
                }
            }
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = '';
      },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, null);
    },
        icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.length < 1) {
      return Container();  //DiscoverPage();
    }
    updateSearchList();

    List<String> matchQuery = [];
    for (var searchItem in searchTerms) {
      if(searchItem.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(searchItem);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

}
