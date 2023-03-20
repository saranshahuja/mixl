import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';



class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload the PDF file to Firebase Storage
  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = basename(file.path);

      try {
        await _storage.ref('pdfs/$fileName').putFile(file);
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('File uploaded successfully!')));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('No file selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page'),
          backgroundColor: Color(0xff2D2D2D)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload PDF File'),
            ),
          ],
        ),
      ),
    );
  }
}
