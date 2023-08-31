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
  tabbar({Key? key, required this.profilpic, required this.userdata})
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
      BodyRecettes(),
      BodyAccueil(
        userdata: widget.userdata,
        profilpic: widget.profilpic,
      ),
      BodyAdd(
        profilpic: widget.profilpic,
        userdata: widget.userdata,
      )
    ];
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.pink,
            splashColor: Platform.isIOS ? Colors.transparent : Colors.grey),
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
            backgroundColor: Color(0xFFECECEC),
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
