import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:coocklen/main.dart';

class AppbarRecettes extends StatelessWidget {
  const AppbarRecettes({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: Center(
        child: const Text(
          "Recettes",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.pink,
    );
  }
}

class BodyRecettes extends StatefulWidget {
  const BodyRecettes({super.key});

  @override
  State<BodyRecettes> createState() => _BodyRecettesState();
}

class _BodyRecettesState extends State<BodyRecettes> {
  void initState() {
    getStart();
  }

  List<Map<String, dynamic>> classic = [];
  List<Map<String, dynamic>> debutant = [];
  List<Map<String, dynamic>> complexe = [];
  List<Map<String, dynamic>> economique = [];
  List<Map<String, dynamic>> exotique = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Les classics :",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 225,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: classic.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<Uint8List?>(
                    future: FrontPic(classic[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Erreur : ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.5)
                                ),
                              ),
                        child: Container(
                          height: 225,
                          width: 180,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(17.5),
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            )
                          ),
                        );
                      } else {
                        return Image.asset("assets/Default.jpg");
                      }         
                    },
                  );
                }
            ),
          )
        ],
      ),
    );
  }

  Future<Uint8List> FrontPic(Map<String, dynamic> laRecette) async {
    Reference ImagePath = await storage.ref().child(laRecette["frontpath"]);
      Uint8List? tempPicture = await ImagePath.getData(1024 * 1024);
      if (tempPicture != null) {
        return tempPicture!;
      } else {
        throw Exception("pas possible");
      }
  }

  void getStart() async {
    Map<String, dynamic> temp = {};
    CollectionReference colRef = db.collection("Recettes");
    try {
      QuerySnapshot docsRef = await colRef.get();
      for (QueryDocumentSnapshot docRef in docsRef.docs) {
        temp = docRef.data() as Map<String, dynamic>;
        if (temp["categorie"] == "classic") {
          setState(() {
            classic.add(temp);
          });
        } else if (temp["categorie"] == "debutant") {
          setState(() {
            debutant.add(temp);
          });
        } else if (temp["categorie"] == "complexe") {
          setState(() {
            complexe.add(temp);
          });
        } else if (temp["categorie"] == "economique") {
          setState(() {
            economique.add(temp);
          });
        } else {
          setState(() {
            exotique.add(temp);
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
