import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:coocklen/main.dart';
import 'package:coocklen/Frames/RecettesTemplate.dart';
import 'tool.dart';

class SearchBars extends SearchDelegate {
  List<String> SearchNames = [];
  List<String> SearchUsersNames = [];
  List<Uint8List> FrontPicture = [];
  Uint8List? BackPicture;
  List<Map<String, dynamic>> SearchContent = [];

  SearchBars(
      {Key? key, required this.SearchNames, required this.SearchUsersNames, required this.SearchContent, required List<Uint8List> this.FrontPicture});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.navigate_before));
  }

  @override
  Widget buildResults(BuildContext context) {
   List<String> matchQuery = [];
    for (var element in SearchNames) {
      if (retirerAccents(element.toLowerCase()).contains(query.toLowerCase()) ||
          element.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    void BackPic(String path, Map<String, dynamic> CategDic) async {
      Reference ImagePath = await storage.ref().child(path);
      Uint8List? tempPicture = await ImagePath.getData(1024 * 1024);
      if (tempPicture != null) {
        BackPicture = tempPicture;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecettesTemplate(
                    Mydico: CategDic, BackPicture: BackPicture)));
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemExtent: 130,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                  onPressed: () {
                    BackPic(
                        SearchContent[index]["backpath"], SearchContent[index]);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17.5),
                          child: Image.memory(
                            FrontPicture[index],
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15),
                        child: Container(
                        width: 195,
                        height: 120,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              SearchNames[index],
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(SearchContent[index]['difficuly'].round(), (index) => Text("🌶️"))
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              NeedConvert(SearchContent[index]["time"]),
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                              ),
                            ),
                          ),
                           Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              SearchUsersNames[index],
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                              ),
                            ),
                          )
                        ],
                      ),
                      ),
                      ),
                    ],
                  )
              )
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var element in SearchNames) {
      if (retirerAccents(element.toLowerCase()).contains(query.toLowerCase()) ||
          element.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }
    void BackPic(String path, Map<String, dynamic> CategDic) async {
      Reference ImagePath = await storage.ref().child(path);
      Uint8List? tempPicture = await ImagePath.getData(1024 * 1024);
      if (tempPicture != null) {
        BackPicture = tempPicture;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecettesTemplate(
                    Mydico: CategDic, BackPicture: BackPicture)));
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemExtent: 130,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                  onPressed: () {
                    BackPic(
                        SearchContent[index]["backpath"], SearchContent[index]);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17.5),
                          child: Image.memory(
                            FrontPicture[index],
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15),
                        child: Container(
                        width: 195,
                        height: 120,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              SearchNames[index],
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(SearchContent[index]['difficuly'].round(), (index) => Text("🌶️"))
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              NeedConvert(SearchContent[index]["time"]),
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                              ),
                            ),
                          ),
                           Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              SearchUsersNames[index],
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                              ),
                            ),
                          )
                        ],
                      ),
                      ),
                      ),
                    ],
                  )
              )
          );
        },
      ),
    );
  }
   String NeedConvert(int MyNumb) {
    if (MyNumb >= 60) {
      return "${(MyNumb / 60).round()} heures";
    } else {
      return "$MyNumb minutes";
    }
  }
}
