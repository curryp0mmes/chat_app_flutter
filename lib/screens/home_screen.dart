import 'dart:io';

import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/firebase/storage_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Text('Logged in as ${currentUser?.email}'),
          Image.network(currentUser?.photoURL ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', width: 100, height: 100,),
          TextButton(onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
            if (result != null) {
              String path = result.files.single.path.toString();
              File file = File(path);

              //TODO upload to Firebase Storage and set profile photourl
              var newURL = await StorageRepo.uploadFile(file: file, subfolder: 'profile');
              setState(() {
                currentUser?.updatePhotoURL(newURL);
              });
            }
          }, child: Text('Change Picture')),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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