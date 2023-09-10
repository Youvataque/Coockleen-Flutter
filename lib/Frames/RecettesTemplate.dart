import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:coocklen/Component/TopRecettes.dart';

import '../main.dart';

class RecettesTemplate extends StatefulWidget {
  Map<String, dynamic> Mydico = {};
  Uint8List? BackPicture;
  RecettesTemplate({
    Key? key,
    required this.Mydico,
    required this.BackPicture
    }) : super(key: key);
  @override
  State<RecettesTemplate> createState() => _RecettesTemplateState();
}

class _RecettesTemplateState extends State<RecettesTemplate> {
  int number = 4;
  int stepperIndex = 0;
  String Error = "";
  List<String> ingredientTitle() {
    List<String> temp = (widget.Mydico["ingredientTitle"] as List)
        .map((item) => item as String)
        .toList();
    return temp;
  }

  List<double> ingredientQuantite() {
    List<double> temp = (widget.Mydico["ingredientQuantite"] as List)
        .map((item) => item as double)
        .toList();
    return temp;
  }

  List<String> ingredientUnit() {
    List<String> temp = (widget.Mydico["ingredientUnit"] as List)
        .map((item) => item as String)
        .toList();
    return temp;
  }

  List<String> etapeTitle() {
    List<String> temp = (widget.Mydico["etapeTitle"] as List)
        .map((item) => item as String)
        .toList();
    return temp;
  }

  List<String> etapeContent() {
    List<String> temp = (widget.Mydico["etapeContent"] as List)
        .map((item) => item as String)
        .toList();
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primarySwatch: Colors.pink),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            if (widget.BackPicture != null)
              TopRecettes(
                  typedit: 1,
                  picturecomp: Image.memory(
                    widget.BackPicture!,
                    fit: BoxFit.cover,
                  ),
                  onModifierPressed: () {
                    print("n'est pas sencé être visible");
                  },
                  PassContext: context,
              ),
            SliverToBoxAdapter(
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                // Parti profil
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      widget.Mydico["title"],
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // part 1
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Difficulté : ",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                            children: List.generate(
                                widget.Mydico["difficuly"].round(),
                                (index) => Text("🌶️",
                                  style: TextStyle(
                                    fontSize: 11
                                  ),
                                )
                            )
                          ),
                      ],
                    ),
                    // part 2
                    Row(
                      children: [
                        Text(
                          "Temps : ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          NeedConvert(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.pink),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 1,
                  color: Colors.black26,
                ),
                SizedBox(
                  height: 35,
                ),
                // parti ingredient
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ingrédients :",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 34,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.pink),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 7),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (number != 1 && number != 0) {
                                      for (var x = 0; x < widget.Mydico["ingredientQuantite"].length; x++) {
                                        widget.Mydico["ingredientQuantite"][x] = (((number - 1) * widget.Mydico["ingredientQuantite"][x]) / number);
                                      }
                                      number -= 1;
                                    }
                                  });

                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size(20, 20),
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right:
                                          10), // Supprimer le rembourrage par défaut
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: Color(0xFFECECEC), fontSize: 24),
                                )),
                          ),
                          Text(
                            "${number} personnes",
                            style: TextStyle(
                                color: Color(0xFFECECEC),
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    for (var x = 0; x < widget.Mydico["ingredientQuantite"].length; x++) {
                                      widget.Mydico["ingredientQuantite"][x] = (((number + 1) * widget.Mydico["ingredientQuantite"][x]) / number);
                                    }
                                    number += 1;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size(20, 20),
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right:
                                          10), // Supprimer le rembourrage par défaut
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: Color(0xFFECECEC), fontSize: 24),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: List.generate(
                        ingredientTitle().length,
                        (index) => ClipRRect(
                            borderRadius: BorderRadius.circular(12.5),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Color(0xFFECECEC),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ingredientTitle()[index],
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink),
                                  ),
                                  Divider(
                                    color: Colors.pink,
                                    indent: 5,
                                    endIndent: 5,
                                    thickness: 1,
                                  ),
                                  Text(
                                    "${ingredientQuantite()[index]} ${ingredientUnit()[index]}",
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink
                                    ),
                                  )
                                ],
                              ),
                            )
                          )
                      ),
                  ),
                ),
                // parti ingredient
                SizedBox(
                  height: 35,
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                  thickness: 1,
                  color: Colors.black26,
                ),
                if (etapeTitle().length != 0)
                  Stepper(
                    physics: NeverScrollableScrollPhysics(),
                    controlsBuilder:
                        (BuildContext context, ControlsDetails controls) {
                      return Row(
                        children: <Widget>[
                          Container(),
                        ],
                      );
                    },
                    steps: etapeTitle().map((element) {
                      var index = etapeTitle().indexOf(element);
                      return Step(
                        isActive: stepperIndex == index,
                        title: Text(etapeTitle()[index]),
                        content: Center(child: Text(etapeContent()[index])),
                      );
                    }).toList(),
                    onStepTapped: (int NewIndex) {
                      setState(() {
                        stepperIndex = NewIndex;
                      });
                    },
                    currentStep: stepperIndex,
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    Error,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  String NeedConvert() {
    int MyNUmb = widget.Mydico["time"];
    if (MyNUmb >= 60) {
      return "${(MyNUmb / 60).round()} heures";
    } else {
      return "$MyNUmb minutes";
    }
  }
}
