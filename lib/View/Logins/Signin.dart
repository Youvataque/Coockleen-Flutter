import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:coocklen/Component/Tabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'Signup.dart';
import 'PasswordReset.dart';

// ignore: must_be_immutable
class Signin extends StatefulWidget {
  Map<String, dynamic> userdata = {};
  Uint8List? profilpic;
  Signin({Key? key, required this.profilpic, required this.userdata})
      : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String Error = "";
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

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
                  height: 80,
                ),
                Text(
                  "Envie d'une sucrerie ?\nConnectez vous !",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Identifiant",
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.pink,
                      )),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: TextField(
                    obscureText: true,
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueGrey.withOpacity(0.2))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.pink.withOpacity(1),
                      )),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 45),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordReset()));
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          Signinto();
                        },
                        child: Text(
                          "Connexion",
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup(
                                      titleTab: [
                                        "Nom",
                                        "Prénom",
                                        "Email",
                                        "Téléphone",
                                        "Mot de passe",
                                        "Mot de passe"
                                      ],
                                      secureTab: [
                                        false,
                                        false,
                                        false,
                                        false,
                                        true,
                                        true
                                      ],
                                      valueTab: [
                                        TextEditingController(),
                                        TextEditingController(),
                                        TextEditingController(),
                                        TextEditingController(),
                                        TextEditingController(),
                                        TextEditingController()
                                      ],
                                    )));
                      },
                      child: Text(
                        "Sinon, rejoignez nous !",
                        style: TextStyle(fontSize: 14),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    Error,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Future Signinto() async {
    try {
      // get user zipped
      UserCredential userZip = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
      User user = userZip.user!;
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString("FirebaseUID", user.uid);
      });
      // si user exist
      GetProfil();
    } catch (error) {
      // Gestion des erreurs
      setState(() {
        Error = ConverLang(error.toString());
      });
      print(error.toString());
    }
  }

  void GetProfil() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.get("FirebaseUID").toString();
      DocumentReference docref = db.collection("Users").doc(user);
      DocumentSnapshot document = await docref.get();
      Map<String, dynamic> temp;
      if (document.exists) {
        temp = document.data() as Map<String, dynamic>;
        setState(() {
          widget.userdata = temp;
        });
        try {
          Reference picture = await storage.ref().child(temp["picture"]);
          final temp2 = await picture.getData(10 * 1024 * 1024);
          setState(() {
            widget.profilpic = temp2;
          });
          Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => tabbar(
                    profilpic: widget.profilpic,
                    userdata: widget.userdata,
                  )));
        } catch (error) {
          print(error);
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  String ConverLang(String lerreur) {
    if (lerreur ==
        "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
      return "Erreur le mot de passe est incorrect ! ";
    } else if (lerreur ==
        "[firebase_auth/invalid-email] The email address is badly formatted.") {
      return "Veullez entrer une adresse email valide !";
    } else if (lerreur ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return "Le compte recherché est introuvable !";
    } else if (lerreur ==
        "[firebase_auth/user-disabled] The user account has been disabled by an administrator.") {
      return "Vôtre compte a été désactivé pour non respect des règles !";
    } else {
      return "Une erreur est survenue !";
    }
  }
}
