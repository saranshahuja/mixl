import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mixl/Pages/Login.dart';
import 'package:mixl/Pages/PlayerView.dart';

class KeywordSearchPage extends StatefulWidget {
  const KeywordSearchPage({Key? key}) : super(key: key);

  @override
  _KeywordSearchPageState createState() => _KeywordSearchPageState();
}

class _KeywordSearchPageState extends State<KeywordSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchKeyword;
  List<Map<String, String>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error while signing out: $e');
    }
  }

  Future<List<Map<String, String>>> _searchFiles(String searchKeyword) async {
    List<Map<String, String>> searchResults = [];

    final ListResult listResult = await FirebaseStorage.instance.ref().list();
    for (final Reference ref in listResult.items) {
      if (ref.name.contains(searchKeyword)) {
        String url = await ref.getDownloadURL();
        searchResults.add({"name": ref.name, "url": url});
      }
    }

    return searchResults;
  }

  Widget _buildSearchResultList(List<Map<String, String>> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final item = searchResults[index];
        return ListTile(
          title: Text(item["name"] ?? ""),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPage( fileUrl: item["url"] as String,
                    filename: item["name"] as String),
              ),
            );
          },
        );
      },
    );
  }

  void _onSearch() async {
    setState(() {
      _searchKeyword = _searchController.text;
    });

    if (_searchKeyword != null && _searchKeyword!.isNotEmpty) {
      _searchResults = await _searchFiles(_searchKeyword!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Color(0xff2D2D2D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search book',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          const Divider(),
          Expanded(
            child: _searchKeyword == null || _searchKeyword!.isEmpty
                ? const Center(child: Text("No search results"))
                : _buildSearchResultList(_searchResults),
          ),
        ],
      ),
    );
  }
}
