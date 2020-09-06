import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:romney/entities/word.dart';
import 'package:romney/ui/pages/words/detail.dart' as wordDetail;
import 'package:romney/ui/pages/words/taggedList.dart';
import 'package:romney/viewmodels/words/taggedList.dart';
import 'package:romney/viewmodels/words/listItem.dart';

class ListItem extends StatelessWidget {
  static const platform = const MethodChannel('dictionary_search');
  final Word word;

  ListItem({this.word});

  @override
  Widget build(BuildContext context) {
    final wordListItemVM = context.watch<WordListItemViewModel>();
    return GestureDetector(
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
              child: ListTile(
            // title: Text(word, style: TextStyle(fontWeight: FontWeight.bold)),
            title: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Text(word.word,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  Text(word.word, style: TextStyle(fontSize: 12.0)),
                ]),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                  value: TaggedWordListViewModel(tag: word.tag),
                                  child: TaggedWordList());
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
              onTap: () => print('Delete'),
            ),
          ],
        ),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //   return wordDetail.Detail(word: word);
          // }));
        });
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
