import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
// les views
import 'package:coocklen/View/Recettes.dart';
import 'package:coocklen/View/Accueil.dart';
import 'package:coocklen/View/AddComponent/Add.dart';

// ignore: must_be_immutable
class tabbar extends StatefulWidget {
  Map<String, dynamic> userdata = {};
  Uint8List? profilpic;
  //Accueil
  List<Map<String, dynamic>> Last = [];
  List<Map<String, dynamic>> Favoris = [];

  //Recettes
  List<Map<String, dynamic>> classic = [];
  List<Map<String, dynamic>> debutant = [];
  List<Map<String, dynamic>> complexe = [];
  List<Map<String, dynamic>> economique = [];
  List<Map<String, dynamic>> exotique = [];
  Map<String, dynamic> SearchNames = {};
  tabbar(
      {Key? key,
      required this.profilpic,
      required this.userdata,
      List<Map<String, dynamic>> this.Last = const [],
      List<Map<String, dynamic>> this.Favoris = const [],
      List<Map<String, dynamic>> this.classic = const [],
      List<Map<String, dynamic>> this.debutant = const [],
      List<Map<String, dynamic>> this.complexe = const [],
      List<Map<String, dynamic>> this.economique = const [],
      List<Map<String, dynamic>> this.exotique = const [],
      Map<String, dynamic> this.SearchNames = const {}})
      : super(key: key);
  @override
  State<tabbar> createState() => _tabbarState();
}

class _tabbarState extends State<tabbar> {
  late List<Widget> BodyTransport;
  List<Widget> AppbarTransport = [
    AppbarRecettes(),
    AppbarAccueil(),
    AppbarAdd()
  ];
  @override
  void initState() {
    super.initState();
    BodyTransport = [
      BodyRecettes(
          classic: widget.classic,
          debutant: widget.debutant,
          complexe: widget.complexe,
          economique: widget.economique,
          exotique: widget.exotique,
          SearchNames: widget.SearchNames),
      BodyAccueil(userdata: widget.userdata, profilpic: widget.profilpic, Last: widget.Last, Favoris: widget.Favoris),
      BodyAdd(profilpic: widget.profilpic, userdata: widget.userdata)
    ];
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.pink,
            splashColor: Platform.isIOS ? Colors.transparent : Colors.grey,
            scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppbarTransport.elementAt(_selectedIndex),
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: BodyTransport,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                activeIcon: Icon(CupertinoIcons.book_fill),
                label: 'Recettes',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                activeIcon: Icon(CupertinoIcons.house_fill),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.plus_app),
                  activeIcon: Icon(CupertinoIcons.plus_app_fill),
                  label: 'Ajouter'),
            ],
            currentIndex: _selectedIndex,
            onTap: OnTapped,
          ),
        ));
  }

  void OnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
