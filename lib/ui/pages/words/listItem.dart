import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:romney/entities/word.dart';
import 'package:romney/ui/pages/words/detail.dart' as wordDetail;
import 'package:romney/ui/pages/words/taggedList.dart';
import 'package:romney/viewmodels/words/taggedList.dart';
import 'package:romney/viewmodels/words/listItem.dart';
import 'package:romney/viewmodels/words/list.dart';
import 'package:romney/viewmodels/words/list_if.dart';

enum DeleteConfirmOption {
  Delete,
  Cancel,
}

class ListItem extends StatelessWidget {
  static const platform = const MethodChannel('dictionary_search');
  final Word word;

  ListItem({this.word});

  @override
  Widget build(BuildContext context) {
    final wordListItemVM = context.watch<WordListItemViewModel>();
    final wordListVM = context.watch<WordViewModel>();
    return GestureDetector(
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
              child: ListTile(
            // title: Text(word, style: TextStyle(fontWeight: FontWeight.bold)),
            title: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(word.word,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  Text(word.word, style: TextStyle(fontSize: 12.0)),
                ]),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Text("description or meaning"),
                  // SizedBox(width: 12),
                  (word.tag != null)
                      ? GestureDetector(
                          child: Container(
                            child: Text(word.tag.tag,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            padding: EdgeInsets.only(
                                top: 1.0, left: 5.0, right: 5.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider.value(
                                  value: wordListVM,
                                  child: TaggedWordList(word.tag));
                              // return TaggedWordList(word.tag);
                            }));
                          },
                        )
                      : Text(""),
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.collections_bookmark,
                    color: word.isInDictionary ? Colors.black87 : Colors.grey,
                  ),
                  onTap: () {
                    this._searchDictionary(word.word);
                    print("dic icon tapped");
                  },
                ),
                SizedBox(width: 10),
                GestureDetector(
                  child: Icon(
                    Icons.star,
                    color: word.isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onTap: () {
                    wordListItemVM.updateIsFavorite();
                    print("star icon tapped");
                  },
                ),
              ],
            ),

            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return wordDetail.Detail(word: word.word);
              }));
            },
          )),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '削除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                _openDeleteDialog(context);
                // wordListItemVM.delete();
                // wordListVM.deleteOne(wordListItemVM.word);
                // print('Delete');
              },
            ),
          ],
        ),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //   return wordDetail.Detail(word: word);
          // }));
        });
  }

  void _openDeleteDialog(BuildContext context) async {
    final wordListItemVM = context.read<WordListItemViewModel>();
    final wordListVM = context.read<WordViewModel>();
    switch (await showDialog<DeleteConfirmOption>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text("削除してOK？"), actions: [
              SimpleDialogOption(
                  child: Text("削除"),
                  onPressed: () {
                    Navigator.pop(context, DeleteConfirmOption.Delete);
                  }),
              SimpleDialogOption(
                  child: Text("戻る"),
                  onPressed: () {
                    Navigator.pop(context, DeleteConfirmOption.Cancel);
                  }),
            ]))) {
      case DeleteConfirmOption.Delete:
        wordListItemVM.delete();
        wordListVM.deleteOne(wordListItemVM.word);
        print("Delete");
        break;
      case DeleteConfirmOption.Cancel:
        print("Cancel");
        break;
    }
  }

  Future<void> _searchDictionary(String queryWord) async {
    String dictionaryLevel;
    try {
      await platform.invokeMethod(
          'searchDictionary', <String, dynamic>{"queryWord": queryWord});
    } on PlatformException catch (e) {
      print(e);
      dictionaryLevel = "Failed to search dictionary";
    }
  }
}
