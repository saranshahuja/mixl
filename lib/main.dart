import 'package:flutter/material.dart';
import 'package:mixl/Pages/Home.dart';
import 'package:mixl/Pages/Login.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        primaryColor: Colors.white70,
        hintColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.white, // Set the default Scaffold background color to black

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black), // Set input field label color to white
            hintStyle: TextStyle(color: Colors.black), // Set input field hint color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          fillColor: Colors.white.withOpacity(0.1), // Set input field fill color to a transparent white
          filled: true, // Enable input field fill color
          ),
        ),

      home: LoginPage(),

    );
  }
}
