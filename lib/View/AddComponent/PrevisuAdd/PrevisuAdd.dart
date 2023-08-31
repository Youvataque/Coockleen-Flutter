import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:coocklen/View/AddComponent/EtapeAdd.dart';
import 'package:coocklen/View/AddComponent/IngredientAdd.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coocklen/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:coocklen/Component/TopRecettes.dart';

class PrevisuAdd extends StatefulWidget {
  Uint8List? Addpicture;
  Uint8List? AddPicture2;
  Uint8List? profilpic;
  Map<String, dynamic> userdata = {};
  double rating = 1;
  TextEditingController time;
  int number;
  TextEditingController title = TextEditingController();
  // ingredient component
  List<String> Ingredient = [];
  List<double> Quantite = [];
  List<String> unitList = [];

  // Etape component
  List<String> StepTitleList = [];
  List<String> StepList = [];

  PrevisuAdd(
      {Key? key,
      required this.title,
      required this.Addpicture,
      required this.AddPicture2,
      required this.profilpic,
      required this.userdata,
      required this.rating,
      required this.Ingredient,
      required this.Quantite,
      required this.StepTitleList,
      required this.StepList,
      required this.unitList,
      required this.number,
      required this.time})
      : super(key: key);

  @override
  State<PrevisuAdd> createState() => _PrevisuAddState();
}

class _PrevisuAddState extends State<PrevisuAdd> {
  int stepperIndex = 0;
  Image Default = Image.asset(
    "assets/Default.jpg",
    fit: BoxFit.cover,
  );
  Image myPicture() {
    return Image.memory(
      widget.AddPicture2!,
      fit: BoxFit.cover,
    );
  }

  Uint8List? AddPicture2;
  bool start = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primarySwatch: Colors.pink),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            TopRecettes(
                typedit: 0,
                picturecomp: widget.AddPicture2 != null ? myPicture() : Default,
                onModifierPressed: getPicture),
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
                      widget.title.text,
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
                                widget.rating.round(), (index) => Text("🌶️"))),
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
                                    if (widget.number != 1 &&
                                        widget.number != 0) {
                                      for (var x = 0;
                                          x < widget.Quantite.length;
                                          x++) {
                                        widget.Quantite[x] =
                                            (((widget.number - 1) *
                                                    widget.Quantite[x]) /
                                                widget.number);
                                      }
                                      widget.number -= 1;
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
                            "${widget.number} personnes",
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
                                    for (var x = 0;
                                        x < widget.Quantite.length;
                                        x++) {
                                      widget.Quantite[x] =
                                          (((widget.number + 1) *
                                                  widget.Quantite[x]) /
                                              widget.number);
                                    }
                                    widget.number += 1;
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
                        widget.Ingredient.length,
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
                                    widget.Ingredient[index],
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
                                    "${widget.Quantite[index].round().toString()} ${widget.unitList[index]}",
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                            ))),
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
                if (widget.StepTitleList.length != 0)
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
                    steps: widget.StepTitleList.map((element) {
                      var index = widget.StepTitleList.indexOf(element);
                      return Step(
                        isActive: stepperIndex == index,
                        title: Text(widget.StepTitleList[index]),
                        content: Center(child: Text(widget.StepList[index])),
                      );
                    }).toList(),
                    onStepTapped: (int NewIndex) {
                      setState(() {
                        stepperIndex = NewIndex;
                      });
                    },
                    currentStep: stepperIndex,
                  ),
                Container(
                  height: 95,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 45,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                back();
                              },
                              child: Text(
                                "Retour",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.5))),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            height: 45,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Enregistrer",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.5))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void back() {
    Navigator.pop(context);
  }

  void getPicture() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // crop
    if (image != null) {
      final ImageCropper _imageCropper = ImageCropper();
      CroppedFile? croppedImage = await _imageCropper.cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ],
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              cancelButtonTitle: 'Annuler',
              doneButtonTitle: 'Terminer',
              aspectRatioLockEnabled: false,
            ),
          ]);
      if (croppedImage != null) {
        // send and set
        try {
          Uint8List temp = await croppedImage.readAsBytes();
          setState(() {
            widget.AddPicture2 = temp;
          });
        } catch (error) {
          print(error);
        }
      }
    }
  }

  String NeedConvert() {
    int MyNUmb = int.tryParse(widget.time.text) ?? 0;
    if (MyNUmb >= 60) {
      return "${(MyNUmb / 60).round()} heures";
    } else {
      return "$MyNUmb minutes";
    }
  }
}
