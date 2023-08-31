import 'package:flutter/material.dart';

class AppbarRecettes extends StatelessWidget {
  const AppbarRecettes({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: Center(
        child: const Text("Recettes",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Colors.pink,
    );
  }
}

class BodyRecettes extends StatelessWidget {
  const BodyRecettes({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("Bienvenue dans les recettes"));
  }
}
