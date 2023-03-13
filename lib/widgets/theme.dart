import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  primaryColor: Color(0xff2D2D2D),
  accentColor: Color(0xff7A51E2),

  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: Colors.grey[800],
    ),
  ),
);