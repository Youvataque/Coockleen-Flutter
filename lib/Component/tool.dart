import 'package:flutter/material.dart';

String retirerAccents(String texteAvecAccents) {
  final Map<String, String> accents = {
    'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
    'ç': 'c',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ñ': 'n',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
    'ý': 'y',
    'ÿ': 'y'
  };
  
  String texteSansAccents = '';
  for (int i = 0; i < texteAvecAccents.length; i++) {
    final char = texteAvecAccents[i];
    texteSansAccents += accents[char] ?? char;
  }
  return texteSansAccents;
}
