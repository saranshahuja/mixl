import 'package:flutter/material.dart';

class KeywordSearchPage extends StatefulWidget {
  const KeywordSearchPage({Key? key}) : super(key: key);

  @override
  _KeywordSearchPageState createState() => _KeywordSearchPageState();
}

class _KeywordSearchPageState extends State<KeywordSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchKeyword;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      _searchKeyword = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: _selectedIndex,
        //onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}