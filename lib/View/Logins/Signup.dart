import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coocklen/main.dart';

// ignore: must_be_immutable
class Signup extends StatefulWidget {
  List<String> titleTab = [];
  List<bool> secureTab = [];
  List<TextEditingController> valueTab = [];
  Signup({
    Key? key,
    required this.titleTab,
    required this.secureTab,
    required this.valueTab,
  }) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String Error = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        color: Colors.pink,
        home: Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Il n'est jamais trop tard !\nInscrivez vous !",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.titleTab.length,
                    itemBuilder: (context, x) {
                      return SignForm(widget.titleTab[x], widget.secureTab[x],
                          widget.valueTab[x]);
                    }),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          Push();
                        },
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(top: 18, bottom: 18)),
                      )),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "En fait j'ai un compte ...",
                        style: TextStyle(fontSize: 14),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    Error,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Padding SignForm(
      String title, bool secure, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 50, right: 50, top: 20),
      child: TextFormField(
        controller: controller,
        obscureText: secure,
        decoration: InputDecoration(
          hintText: title,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.2))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.pink.withOpacity(1),
          )),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  void Push() async {
    if (widget.valueTab[4].text == widget.valueTab[5].text) {
      // enregistrement du Users et de ses données
      if (!(widget.valueTab[0].text.isEmpty)) {
        if (!(widget.valueTab[1].text.isEmpty)) {
          // Début code principale
          try {
            // création user
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: widget.valueTab[2].text,
                password: widget.valueTab[4].text);
            // ajout des informations dans firestore
            UserCredential User = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: widget.valueTab[2].text,
                    password: widget.valueTab[4].text);
            DocumentReference docref =
                db.collection("Users").doc(User.user!.uid);
            docref.set({
              'nom': widget.valueTab[0].text,
              'prenom': widget.valueTab[1].text,
              'mail': widget.valueTab[2].text,
              'phone': widget.valueTab[3].text,
              'picture': "Profil/Default/pp.jpg"
            });
            // retour à login
            Navigator.pop(context);
          } catch (error) {
            setState(() {
              Error = ConvertLang(error.toString());
            });
          }
          // fin code principale
        } else {
          setState(() {
            Error = "Le Prenom est obligatoire !";
          });
        }
      } else {
        setState(() {
          Error = "Le nom est obligatoire !";
        });
      }
    } else {
      // erreur
      setState(() {
        Error = "Les deux mots de passes ne sont pas identiques !";
      });
    }
    ;
  }

  String ConvertLang(String lerreur) {
    if (lerreur ==
        "[firebase_auth/weak-password] Password should be at least 6 characters") {
      return "Erreur ! Les mots de passes doivent être identiques et comporter 6 caractères !";
    } else if (lerreur ==
        "[firebase_auth/missing-email] An email address must be provided.") {
      return "Erreur ! Une adresse email est obligatoire !";
    } else {
      return "Une erreur est survenue :/";
    }
  }
}
