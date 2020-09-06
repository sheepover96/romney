import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'package:romney/viewmodels/words/add.dart';

const TagList = <DropdownMenuItem>[
  DropdownMenuItem(child: Text("One"), value: 1),
  DropdownMenuItem(child: Text("Two"), value: 2),
  DropdownMenuItem(child: Text("Three"), value: 3),
  // "One",
  // "Two",
  // "Three",
  // "One",
  // "Two",
  // "Three",
  // "One",
  // "Two",
  // "Three"
];

class AddByKeyboard extends StatelessWidget {
  static const platform = const MethodChannel('dictionary_search');

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

  @override
  Widget build(BuildContext context) {
    final wordAddModel = context.watch<WordAddViewModel>();
    return Scaffold(
        appBar: AppBar(
          title: Text("単語追加"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "単語",
                ),
                minLines: 1,
                maxLength: 20,
                maxLengthEnforced: false,
                onChanged: (String value) {
                  wordAddModel.word = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "読み方"),
                onChanged: (String value) {
                  wordAddModel.reading = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "意味"),
                maxLines: 5,
                onChanged: (String value) {
                  wordAddModel.meaning = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: wordAddModel.fetchTags(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return SearchableDropdown.single(
                      label: Text("タグ"),
                      items: wordAddModel.tagList
                          .map((tag) => DropdownMenuItem(
                                child: Text(tag.tag),
                                value: tag,
                              ))
                          .toList(),
                      value: wordAddModel.tag,
                      onChanged: (value) {
                        wordAddModel.tag = value;
                      },
                      onClear: () {},
                      isExpanded: true,
                    );
                  }),
              Consumer<WordAddViewModel>(builder: (context, value, child) {
                return Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: wordAddModel.isWordValid
                        ? Colors.blue
                        : Colors.blueGrey,
                    onPressed: () async {
                      if (wordAddModel.word != '') {
                        await wordAddModel.add();
                        Navigator.of(context).pop(wordAddModel.word);
                      }
                      // final wordInfo = new db.WordInfo(word: _word, meaning: "");
                      // db.DBClient.insertWord(wordInfo);
                      // final res = await db.DBClient.db.query("tutorial");
                    },
                    child: Text('リスト追加', style: TextStyle(color: Colors.white)),
                  ),
                );
              }),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    this._searchDictionary(wordAddModel.word);
                  },
                  child: Text('検索', style: TextStyle(color: Colors.white)),
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Text('キャンセル'),
              //   ),
              // ),
            ],
          ),
        ));
  }
}