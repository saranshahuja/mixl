import 'package:flutter/material.dart';

import 'PlayerView.dart';


class homeScreen extends StatelessWidget {
   List<String> songs = [  'Song 1',    'Song 2',    'Song 3',    'Song 4',    'Song 5',  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mixl",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(songs[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(songName: songs[index]),
                    ),
                  );
                },
              );
            },
          ),
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
