import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocklen/View/Logins/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:coocklen/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

// ignore: must_be_immutable
class Profil extends StatefulWidget {
  Map<String, dynamic> userdata = {};
  Uint8List? profilpic;
  Profil({Key? key, required this.profilpic, required this.userdata})
      : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              navigateToAccueilAndReturn();
            },
          ),
          elevation: 2,
          title: Padding(
            padding: EdgeInsets.only(right: 30),
            child: Center(
              child: const Text(
                "Profil utilisateur",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          backgroundColor: Colors.pink,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              if (widget.profilpic != null)
                ClipOval(
                  child: IconButton(
                    onPressed: () {
                      SelectPicture();
                    },
                    icon: FittedBox(
                      fit: BoxFit.contain,
                      child: CircleAvatar(
                        radius: 160,
                        foregroundImage: MemoryImage(widget.profilpic!),
                      ),
                    ),
                    iconSize: 160,
                  ),
                ),
              ProfilCard(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userdata["nom"].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.pink),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.userdata["prenom"].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.pink),
                    )
                  ],
                ),
              ),
              ProfilCard(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userdata["mail"].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.pink),
                  ),
                ],
              )),
              ProfilCard(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userdata["phone"].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.pink),
                  ),
                ],
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 70, right: 70),
                  child: ElevatedButton(
                    onPressed: () {
                      SignOut();
                    },
                    child: Text(
                      "Deconnexion",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToAccueilAndReturn() async {
    Map<String, dynamic> updatedData = {
      'updatedProfilpic': widget.profilpic,
      'updatedUserdata': widget.userdata,
    };
    Navigator.pop(context, updatedData);
  }

  Future SignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("FirebaseUID");
      setState(() {
        widget.userdata = {};
        widget.profilpic = null;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Signin(
                    userdata: widget.userdata,
                    profilpic: widget.profilpic,
                  )));
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> SelectPicture() async {
    // pick
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // crop
    if (image != null) {
      final ImageCropper _imageCropper = ImageCropper();
      CroppedFile? croppedImage = await _imageCropper.cropImage(
          cropStyle: CropStyle.circle,
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ],
          uiSettings: [
            AndroidUiSettings(),
            IOSUiSettings(
              cancelButtonTitle: 'Annuler',
              doneButtonTitle: 'Terminer',
              aspectRatioLockEnabled: true,
            ),
          ]);
      // send and set
      if (croppedImage != null) {
        try {
          print(croppedImage.path);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String user = prefs.get("FirebaseUID").toString();
          Reference pictureRef =
              await storage.ref().child("Profil/$user/pp.jpg");
          await pictureRef.putFile(File(croppedImage.path));
          DocumentReference docref = db.collection("Users").doc(user);
          docref
              .set({'picture': "Profil/$user/pp.jpg"}, SetOptions(merge: true));
          setState(() {
            widget.profilpic = File(croppedImage.path).readAsBytesSync();
          });
        } catch (error) {
          print(error);
        }
      }
    }
  }

  Column ProfilCard(Row content) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: content),
        )
      ],
    );
  }
}
