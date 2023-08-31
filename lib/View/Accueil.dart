import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// View
import 'package:coocklen/View/Profil.dart';

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
  BodyAccueil({Key? key, required this.profilpic, required this.userdata})
      : super(key: key);

  @override
  State<BodyAccueil> createState() => _BodyAccueilState();
}

class _BodyAccueilState extends State<BodyAccueil> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nos derniers ajouts :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(height: 300, child: Colone(Axis.horizontal)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Les plus populaires :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(height: 300, child: Colone(Axis.horizontal)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Vos favoris :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int x) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              "Favoris button",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics())
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(CupertinoIcons.person_circle),
              color: Color(0xFFECECEC),
              iconSize: 50,
              onPressed: () {
                navigateToProfil();
              },
            ),
          ),
        )
      ],
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

  Container Colone(Axis axis) {
    return Container(
      height: 130,
      child: ListView.builder(
          scrollDirection: axis,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                width: 200,
                height: 130,
                color: Colors.white,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side: BorderSide(
                              color: Colors.pink,
                              width: 2,
                            ))),
                    child: Text(
                      "coucou",
                      style: TextStyle(color: Colors.pink),
                    )),
              ),
            );
          }),
    );
  }
}
