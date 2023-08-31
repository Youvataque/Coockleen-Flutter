import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EtapeAdd extends StatefulWidget {
  TextEditingController StepTitle = TextEditingController();
  TextEditingController Step = TextEditingController();
  List<String> StepTitleList = [];
  List<String> StepList = [];
  int opentype = 0;
  int index;
  EtapeAdd(
      {Key? key,
      required this.StepTitleList,
      required this.StepList,
      required this.StepTitle,
      required this.Step,
      required this.opentype,
      this.index = 0})
      : super(key: key);
  @override
  State<EtapeAdd> createState() => _EtapeAddState();
}

class _EtapeAddState extends State<EtapeAdd> {
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
                controller: widget.StepTitle,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Entrez le titre de l'étape",
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
            child: Container(
              height: 120,
              width: 250,
              child: TextField(
                controller: widget.Step,
                maxLines: 7,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Inscrivez ici le déroulement de l'étape",
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
      widget.StepTitleList.add(widget.StepTitle.text.trim());
      widget.StepList.add(widget.Step.text.trim());
    });
    widget.StepTitle.text = "";
    widget.Step.text = "";
    Navigator.pop(context);
  }

  void IngreEditfunc() {
    setState(() {
      widget.StepTitleList[widget.index] = widget.StepTitle.text.trim();
      widget.StepList[widget.index] = widget.Step.text.trim();
    });
    widget.StepTitle.text = "";
    widget.Step.text = "";
    Navigator.pop(context);
  }
}
