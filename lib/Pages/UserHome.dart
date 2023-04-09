import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixl/Pages/PlayerView.dart';



class UserHome extends StatefulWidget {
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

   List<String> _fileNames = ['Test.txt'];

  Future<String> _loadFileContents(String fileName) async {
    // Load the file contents for the given file name
    final file = await File(fileName).readAsString();
    return file;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color(0xff2D2D2D),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: [

              Container(

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
    ),
                child: ListTile(
                  hoverColor: Colors.deepPurple,
                  title: Text('Test.txt',style: TextStyle(color: Colors.white),),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPage( filePath: 'lib/assets/Test.txt',),
                    ),
                  ),
                )



                ),

    //           ListTile(
    //             title: Text('Change Email',style: TextStyle(color: Colors.white),),
    // )

            ],
          ),
        ],
      ),
    );




  }

  Future<String> loadPadFile(String fileName) async {
    return await rootBundle.loadString('lib/assets/$fileName');
  }
}
