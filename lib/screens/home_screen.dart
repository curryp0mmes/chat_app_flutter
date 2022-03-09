import 'dart:io';

import 'package:chat_app/firebase/authentication.dart';
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
  int _counter = 0;
  int _selectedScreen = 0;
  User? currentUser = AuthenticationTools.getUser();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text("ChatApp"),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        onTap: (index){
          setState(() {
            if(index == 1) {
              showSearch(context: context, delegate: CustomSearchDelegate(),);
            } else {
              _selectedScreen = index;
            }
          });
        },
        currentIndex: _selectedScreen,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
        child: Column(
          children: [
            Text('Logged in as ${currentUser?.email}'),
            Image.network(currentUser?.photoURL ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', width: 100, height: 100,),
            TextButton(onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
              if (result != null) {
                String path = result.files.single.path.toString();
                
                var file = await ImageCropper().cropImage(sourcePath: path, compressQuality: 40, aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)); //TODO fix deprecated

                //TODO upload to Firebase Storage and set profile photoUrl
                var newURL = await StorageRepo.uploadFile(file: file!, subfolder: 'profile');
                setState(() {
                  currentUser?.updatePhotoURL(newURL);
                });
              }
            }, child: const Text('Change Picture')),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatWindow()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.message),
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
