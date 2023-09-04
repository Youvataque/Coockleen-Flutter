// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IngredientAdd extends StatefulWidget {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController unit = TextEditingController();
  List<String> ingredient = [];
  List<double> quantite = [];
  List<String> unitList = [];
  int opentype = 0;
  int index;
  IngredientAdd(
      {Key? key,
      required this.title,
      required this.content,
      required this.unit,
      required this.ingredient,
      required this.quantite,
      required this.unitList,
      required this.opentype,
      this.index = 0})
      : super(key: key);
  @override
  State<IngredientAdd> createState() => _IngredientAddState();
}

class _IngredientAddState extends State<IngredientAdd> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              height: 45,
              width: 250,
              child: TextField(
                controller: widget.title,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Entrez vôtre ingrédient",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.pink,
                  ),
                  contentPadding: EdgeInsets.only(top: 3),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(17.5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.circular(17.5)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 95,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true), // Autorise les nombres décimaux
                  controller: widget.content,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Sa quantité",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.pink,
                    ),
                    contentPadding: EdgeInsets.only(top: 3),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(17.5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(17.5)),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 45,
                width: 145,
                child: TextField(
                  controller: widget.unit,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Ainsi que son unité",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.pink,
                    ),
                    contentPadding: EdgeInsets.only(top: 3),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(17.5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(17.5)),
                  ),
                ),
              ),
            ],
          )),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              "* Par exemple : 600g",
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.none),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          if (widget.opentype == 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(onPressed: IngreAddfunc, child: Text("Ok")),
            )
          else if (widget.opentype == 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    IngreEditfunc();
                  },
                  child: Text("Modifier")),
            )
        ],
      ),
    );
  }

  void IngreAddfunc() {
    setState(() {
      widget.ingredient.add(widget.title.text.trim());
      widget.quantite.add(double.tryParse(widget.content.text) ?? 0);
      widget.unitList.add(widget.unit.text.trim());
      print(widget.ingredient);
    });
    widget.title.text = "";
    widget.content.text = "";
    widget.unit.text = "";
    Navigator.pop(context);
  }

  void IngreEditfunc() {
    setState(() {
      widget.ingredient[widget.index] = widget.title.text.trim();
      widget.quantite[widget.index] = double.tryParse(widget.content.text) ?? 0;
      widget.unitList[widget.index] = widget.unit.text.trim();
    });
    widget.title.text = "";
    widget.content.text = "";
    widget.unit.text = "";
    Navigator.pop(context);
  }
}
