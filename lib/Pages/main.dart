import 'package:flutter/material.dart';
import 'package:mixl/Pages/Login.dart';
import 'homeScreen.dart';
//kxz
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//this is a test

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mixl',
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,
      ),
      home: homeScreen(),
    );
  }
}
