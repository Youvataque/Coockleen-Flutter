import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// View
import 'package:coocklen/View/Profil.dart';
import '../Frames/RecettesTemplate.dart';
import '../main.dart';

class AppbarAccueil extends StatelessWidget {
  const AppbarAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CoockLeen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Image.asset('assets/WhiteLogo.png',
                width: 50, height: 50, fit: BoxFit.fitWidth),
          ],
        ),
      ),
      backgroundColor: Colors.pink,
    );
  }
}

// ignore: must_be_immutable
class BodyAccueil extends StatefulWidget {
  Map<String, dynamic> userdata = {};
  Uint8List? profilpic;
  List<Map<String, dynamic>> Last = [];
  List<Map<String, dynamic>> Favoris = [];
  BodyAccueil(
      {Key? key,
      required this.profilpic,
      required this.userdata,
      required this.Last,
      required this.Favoris})
      : super(key: key);

  @override
  State<BodyAccueil> createState() => _BodyAccueilState();
}

class _BodyAccueilState extends State<BodyAccueil> {
  Uint8List? BackPicture;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          RecettesParCategorie(widget.Last, "Nos dernières recettes :"),
          Container(
            height: 45,
            width: 340,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.5))),
                onPressed: () {
                  navigateToProfil();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 275,
                      child: Text(
                        "Ici votre profil",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Icon(CupertinoIcons.profile_circled),
                    SizedBox(
                      width: 5,
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 7.5,
          ),
          Container(
            height: 45,
            width: 340,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.5))),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 275,
                      child: Text(
                        "Et la vos recettes",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Icon(CupertinoIcons.book_fill),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ),
          ),
          SizedBox(
            height: 15,
          ),
          RecettesParCategorie(widget.Favoris, "Vos recettes favorites :"),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Future<void> navigateToProfil() async {
    final returnedData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Profil(
          profilpic: widget.profilpic,
          userdata: widget.userdata,
        ),
      ),
    );

    if (returnedData != null) {
      setState(() {
        widget.profilpic = returnedData['updatedProfilpic'];
        widget.userdata = returnedData['updatedUserdata'];
      });
    }
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
                  )));
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
                                BackPic(CategList[index]["backpath"],
                                    CategList[index]);
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
