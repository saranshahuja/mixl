import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  List<String> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<File> _downloadFile(String url, String filename) async {
    final ref = FirebaseStorage.instance.ref().child(url);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    await ref.writeToFile(file);
    return file;
  }
  }

  Future<void> _loadPdfFiles() async {
    final ListResult result = await FirebaseStorage.instance.ref().listAll();
    final List<Reference> references = result.items;

    for (final ref in references) {
      if (ref.name.endsWith('.pdf')) {
        final url = await ref.getDownloadURL();
        final filename = ref.name;
        final file = await _downloadFile(url, filename);
        _pdfFiles.add(file.path);
      }
    }

    print('PDF files loaded successfully: $_pdfFiles');

    setState(() {
      var _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Files'),
      ),
      body: _pdfFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _pdfFiles.length,
        itemBuilder: (context, index) {
          final file = File(_pdfFiles[index]);
          final filename = path.basename(file.path);
          return ListTile(
            title: Text(filename),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewPage(pdfUrl: file.path),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;

  PdfViewPage({required this.pdfUrl});

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  late PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: widget.pdfUrl,
        onRender: (pages) => print('$pages pages rendered'),
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController = pdfViewController;
        },
      ),
    );
  }
}