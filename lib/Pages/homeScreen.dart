import 'package:flutter/material.dart';

import 'PlayerView.dart';


class homeScreen extends StatelessWidget {
   List<String> songs = [  'Song 1',    'Song 2',    'Song 3',    'Song 4',    'Song 5',  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2d2d2d),
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
              return Expanded(

                child: ListTile(
                  tileColor: const Color(0xff252525),
                  title: Text(songs[index],textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayPage(songName: songs[index]),
                      ),
                    );
                  },
                ),
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
