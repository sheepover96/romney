import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:romney/ui/pages/words/listItem.dart' as wordItem;
import 'package:romney/ui/pages/words/taggedListItem.dart';
import 'package:romney/ui/pages/words/addByKeyboard.dart' as wordAddByKeyboard;
import 'package:romney/viewmodels/words/add.dart';
import 'package:romney/viewmodels/words/list.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/entities/tag.dart';
import 'package:romney/viewmodels/words/listItem.dart';
import 'package:romney/viewmodels/words/taggedList.dart';

enum BottomNavOptions {
  WordList,
  TagList,
  Quiz,
}

class TaggedWordList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taggedWordListVM = context.watch<TaggedWordListViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Example title')),
      body: FutureBuilder(
          future: taggedWordListVM.fetchTaggedWords(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListView.builder(
                itemCount: taggedWordListVM.getList().length,
                itemBuilder: (context, index) {
                  return _buildItem(taggedWordListVM.getOne(index));
                  // return _buildItem(wordList[index]['word']);
                });
            // return _buildItemList();
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Container(
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.orangeAccent,
        onPressed: () async {
          _openDialog(context);
        },
      ),
    );
  }

  Widget _buildItem(Word word) {
    return ChangeNotifierProvider<WordListItemViewModel>.value(
        value: WordListItemViewModel(word: word),
        child: TaggedListItem(word: word));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      // pageBuilder: (context, animation, secondaryAnimation) => MyForm(),
      pageBuilder: (context, animation, secondaryAnimation) =>
          wordAddByKeyboard.AddByKeyboard(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.8);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: ChangeNotifierProvider<WordAddViewModel>.value(
              value: WordAddViewModel(), child: child),
        );
      },
      fullscreenDialog: true,
    );
  }

  void _openDialog(BuildContext context) async {
    final taggedWordListModel = context.read<TaggedWordListViewModel>();
    switch (await showDialog<BottomNavOptions>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Center(child: Text("単語の追加")),
              children: <Widget>[
                SimpleDialogOption(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.create, size: 40.0),
                              Text("入力")
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context, BottomNavOptions.WordList);
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo_camera, size: 40.0),
                              Text("写真")
                            ],
                          ),
                          onTap: () {
                            print("camera");
                          },
                        ),
                        GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.photo, size: 40.0),
                                Text("画像")
                              ],
                            ),
                            onTap: () {
                              print("image");
                            }),
                        // Icon(Icons.photo),
                        // SizedBox(width: 12),
                        // Text("tesutossu")
                      ]),
                ),
              ],
            ))) {
      case BottomNavOptions.WordList:
        // final newWord = await Navigator.of(context).push(_createRoute());
        final newWord = await Navigator.of(context).push(_createRoute());
        if (newWord != null) {
          // wordModel.addWord(newWord);
        }
      // print("hogehoge");
    }
  }
}
