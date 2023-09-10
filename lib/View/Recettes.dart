import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocklen/Frames/RecettesTemplate.dart';
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
  Uint8List? BackPicture;
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
          if (classic.length != 0)
            RecettesParCategorie(classic, "Nos classics :"),
          if (debutant.length != 0)
            RecettesParCategorie(debutant, "Pour débuter sans accros :"),
          if (complexe.length != 0)
            RecettesParCategorie(complexe, "Afin de ravir les plus agairis :"),
          if (economique.length != 0)
            RecettesParCategorie(
                economique, "Sans oublier les petites bourses :"),
          if (exotique.length != 0)
            RecettesParCategorie(exotique, "Envie de partir à l'aventure ?")
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

  void BackPic(String path, Map<String, dynamic> CategDic) async {
    Reference ImagePath = await storage.ref().child(path);
    Uint8List? tempPicture = await ImagePath.getData(1024 * 1024);
    if (tempPicture != null) {
      setState(() {
        BackPicture = tempPicture;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecettesTemplate(
            Mydico: CategDic,
            BackPicture: BackPicture,
          )
        )
      );
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

  Column RecettesParCategorie(
      List<Map<String, dynamic>> CategList, String titreCateg) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titreCateg,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 219,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: CategList.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<Uint8List?>(
                  future: FrontPic(CategList[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Erreur : ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                BackPic(classic[index]["backpath"], CategList[index]);
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(17.5)),
                                  backgroundColor: Colors.transparent),
                              child: Container(
                                  height: 175,
                                  width: 156,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(17.5),
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                                width: 156,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      CategList[index]["title"],
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                )),
                            Container(
                                width: 156,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                        CategList[index]["difficuly"].round(),
                                        (index) => Text("🌶️")),
                                  ),
                                ))
                          ],
                        ),
                      );
                    } else {
                      return Image.asset("assets/Default.jpg");
                    }
                  },
                );
              }),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
