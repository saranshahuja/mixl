import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;
  final void Function(int, int)? onPageChanged;

  const PdfViewPage({
    Key? key,
    required this.pdfUrl,
    required this.pdfName,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            onPageChanged: (page, total) {
              setState(() {
                _totalPages = total!;
                _currentPage = page!;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(page!, total!);
              }
            },
            onError: (error) {
              print(error.toString());
            },
            onRender: (_pages) {
              setState(() {
                _isLoading = false;
                _totalPages = _pages!;
              });
            },
          ),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.arrow_upward),
            onPressed: () {
              if (_currentPage > 0) {
                setState(() {
                  _isLoading = true;
                  _currentPage -= 1;
                });
                _pageController.animateToPage(
                  _currentPage,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          SizedBox(height: 16),
          Text('${_currentPage + 1}/$_totalPages'),
          SizedBox(height: 16),
          FloatingActionButton(
            child: Icon(Icons.arrow_downward),
            onPressed: () {
              if (_currentPage < _totalPages - 1) {
                setState(() {
                  _isLoading = true;
                  _currentPage += 1;
                });
                _pageController.animateToPage(
                  _currentPage,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
