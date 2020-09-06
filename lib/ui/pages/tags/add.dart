import 'package:flutter/material.dart';

import 'package:romney/viewmodels/tags/add.dart';

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tagAddModel = TagAddViewModel();
    return Scaffold(
        appBar: AppBar(
          title: Text("タグ追加"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "タグ",
                ),
                maxLength: 20,
                maxLengthEnforced: false,
                onChanged: (String value) {
                  tagAddModel.tag = value;
                },
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () async {
                    // final wordInfo = new db.WordInfo(word: _word, meaning: "");
                    // db.DBClient.insertWord(wordInfo);
                    await tagAddModel.add();
                    Navigator.of(context).pop(tagAddModel.tag);
                    // final res = await db.DBClient.db.query("tutorial");
                  },
                  child: Text('追加', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }
}
