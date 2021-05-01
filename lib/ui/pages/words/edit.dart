import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Edit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                initialValue: "test",
                decoration: InputDecoration(
                  labelText: "単語",
                ),
                minLines: 1,
                maxLength: 20,
                maxLengthEnforced: false,
                onChanged: (String value) {
                  // wordAddModel.word = value;
                },
              ),
            ]),
      ),
    );
  }
}
