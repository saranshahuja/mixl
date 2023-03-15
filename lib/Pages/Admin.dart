import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Color(0xff252525),
       title: Text('Admin',textAlign: TextAlign.center,),
     ),
    );
  }
}
