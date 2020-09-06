import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:romney/ui/pages/words/list.dart' as wordsList;
import 'package:romney/viewmodels/words/list.dart';
import 'package:romney/ui/pages/tags/list.dart' as tagList;
import 'package:romney/viewmodels/tags/list.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final _pageWidgets = [
    ChangeNotifierProvider<WordViewModel>.value(
        value: WordViewModel(), child: wordsList.WordList()),
    // ChangeNotifierProvider<WordViewModel>(
    //     create: (_) => WordViewModel(), child: wordsList.WordList()),
    // wordsList.List(),
    ChangeNotifierProvider<TagListViewModel>.value(
        value: TagListViewModel(), child: tagList.TagList()),
    Scaffold(
      body: Center(child: Text("center")),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('単語')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), title: Text('タグ')),
          BottomNavigationBarItem(
              icon: Icon(Icons.grade), title: Text('Bookmark')),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);
}
