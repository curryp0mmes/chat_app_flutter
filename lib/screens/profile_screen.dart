import 'package:mkship_app/constants.dart';
import 'package:mkship_app/firebase/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

import '../firebase/storage_repo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _displayNameController = TextEditingController();

  @override
  void initState() {
    _displayNameController.text = DatabaseHandler.currentUser?.displayName ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData currentUser = DatabaseHandler.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 8.0)),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            child: FadeInImage.assetNetwork(placeholder: Constants.emptyProfilePicAsset, image: currentUser.photoURL ?? Constants.emptyProfilePic)
          ),
          TextButton(onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
            if (result != null) {
              String path = result.files.single.path.toString();

              var file = await ImageCropper().cropImage(sourcePath: path, compressQuality: 40, aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)); //TODO fix deprecated

              var newURL = await StorageRepo.uploadFile(file: file!, subfolder: 'profile');
              setState(() {
                currentUser.updatePhotoURL(newURL);
              });
            }
          }, child: const Text('Change Picture')),
          Padding(padding: EdgeInsets.all(8.0), child: TextField(
            decoration: InputDecoration(labelText: "Your Name"),
            controller: _displayNameController,
            onChanged: (text) {
              currentUser.updateDisplayName(text);
            },
          )),
        ]
      ),
    );
  }
}
