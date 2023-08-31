import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController email = TextEditingController();
  String Error = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    "Aie, il y a un étourdi ...\nOn a la solution !",
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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Nous allons vous envoyer un mail de réinitilisation :",
                      style: TextStyle(fontSize: 14, color: Colors.pink),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Vôtre email",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.pink,
                        )),
                        fillColor: Colors.white,
                        filled: true,
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
                            Passwordres();
                          },
                          child: Text(
                            "Envoyer",
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
                          "Je ne suis pas étoudi !",
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
          ),
        ),
      ),
    );
  }

  Future<void> Passwordres() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      setState(() {
        Error = "Un mail vous a été envoyé !";
      });
    } catch (error) {
      setState(() {
        Error = Langconv(error.toString());
        print(error);
      });
    }
  }

  String Langconv(String erreur) {
    if (erreur ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return "Aucun utilisateur n'utilise cet email !";
    } else if (erreur ==
        "[firebase_auth/missing-email] An email address must be provided.") {
      return "Il est nécéssaire de préciser un email ^^";
    } else if (erreur ==
        "[firebase_auth/invalid-email] The email address is badly formatted.") {
      return "Ceci n'est pas un email ...";
    } else {
      return "Une erreur est survenue";
    }
  }
}
