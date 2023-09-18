import 'dart:typed_data';
import 'package:coocklen/View/Logins/Signin.dart';
import 'package:coocklen/Component/Tabbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> userdata = {};
  Uint8List? profilpic;
  @override
  void initState() {
    super.initState();
    GetProfil();
    getRecettes();
    getAccueil();
  }

  // Accueil
  List<Map<String, dynamic>> Last = [];
  List<Map<String, dynamic>> Favoris = [];
  // Recettes
  List<Map<String, dynamic>> classic = [];
  List<Map<String, dynamic>> debutant = [];
  List<Map<String, dynamic>> complexe = [];
  List<Map<String, dynamic>> economique = [];
  List<Map<String, dynamic>> exotique = [];
  Map<String, dynamic> SearchNames = {};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text("Erreur: ${snapshot.error}");
            } else {
              return (snapshot.data == true)
                  ? tabbar(
                      profilpic: profilpic,
                      userdata: userdata,
                      Last: Last,
                      classic: classic,
                      debutant: debutant,
                      complexe: complexe,
                      economique: economique,
                      exotique: exotique,
                      SearchNames: SearchNames)
                  : Signin(
                      profilpic: profilpic,
                      userdata: userdata,
                    );
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firebaseUID = prefs.getString("FirebaseUID");

    if (firebaseUID != null) {
      return true;
    } else {
      return false;
    }
  }

  void GetProfil() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.get("FirebaseUID").toString();
      DocumentReference docref = db.collection("Users").doc(user);
      DocumentSnapshot document = await docref.get();
      Map<String, dynamic> temp;
      if (document.exists) {
        temp = document.data() as Map<String, dynamic>;
        setState(() {
          userdata = temp;
        });
        try {
          Reference picture = await storage.ref().child(temp["picture"]);
          final temp2 = await picture.getData(10 * 1024 * 1024);
          setState(() {
            profilpic = temp2;
          });
        } catch (error) {
          print(error);
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void getAccueil() async {
    Map<String, dynamic> temp = {};
    CollectionReference colRef = await db.collection("Last");
    try {
      QuerySnapshot docsRef = await colRef.get();
      for (QueryDocumentSnapshot docRef in docsRef.docs) {
        if (docRef.id != "Tab") {
          temp = docRef.data() as Map<String, dynamic>;
          setState(() {
            Last.add(temp);
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void getRecettes() async {
    Map<String, dynamic> temp = {};
    CollectionReference colRef = db.collection("Recettes");
    try {
      QuerySnapshot docsRef = await colRef.get();
      for (QueryDocumentSnapshot docRef in docsRef.docs) {
        temp = docRef.data() as Map<String, dynamic>;
        if (temp["categorie"] == "classic") {
          setState(() {
            classic.add(temp);
            SearchNames[temp["title"]] = temp;
          });
        } else if (temp["categorie"] == "debutant") {
          setState(() {
            debutant.add(temp);
            SearchNames[temp["title"]] = temp;
          });
        } else if (temp["categorie"] == "complexe") {
          setState(() {
            complexe.add(temp);
            SearchNames[temp["title"]] = temp;
          });
        } else if (temp["categorie"] == "economique") {
          setState(() {
            economique.add(temp);
            SearchNames[temp["title"]] = temp;
          });
        } else {
          setState(() {
            exotique.add(temp);
            SearchNames[temp["title"]] = temp;
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
