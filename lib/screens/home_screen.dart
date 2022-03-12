import 'dart:io';

import 'package:chat_app/custom_widgets/swiping_area.dart';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/firebase/database.dart';
import 'package:chat_app/firebase/storage_repo.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedScreen = 0;
  static final User? _currentCredentials = AuthenticationTools.getUser();
  final UserData? _currentUser = DatabaseHandler.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text("mk:ship"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,

        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: const Text("Logout"), onTap: () {
              setState(() {
                AuthenticationTools.logout();
              });
              }
            ,)
          ])
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
            } else if(index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatWindow()));
            } else{
              _selectedScreen = index;
            }
          });
        },
        currentIndex: _selectedScreen,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SwipingArea(),
            const Padding(padding: EdgeInsets.all(30)),
            Text('Logged in as ${_currentUser?.email}'),
            Image.network(_currentUser?.photoURL ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', width: 100, height: 100,),
            TextButton(onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
              if (result != null) {
                String path = result.files.single.path.toString();
                
                var file = await ImageCropper().cropImage(sourcePath: path, compressQuality: 40, aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)); //TODO fix deprecated

                //TODO upload to Firebase Storage and set profile photoUrl
                var newURL = await StorageRepo.uploadFile(file: file!, subfolder: 'profile');
                setState(() {
                  _currentUser?.updatePhotoURL(newURL);
                });
              }
            }, child: const Text('Change Picture')),

          ],
        ),
      ),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Test',
    'ListItem',
    'SearchResult',
    'Bla',
    'Test2',
    'Test3',
  ];

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

}
