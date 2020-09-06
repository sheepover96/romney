import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:romney/entities/tag.dart';
import 'package:romney/ui/pages/words/taggedList.dart';
import 'package:romney/viewmodels/words/taggedList.dart';

class ListItem extends StatelessWidget {
  final Tag tag;

  ListItem({this.tag});

  @override
  Widget build(BuildContext context) {
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
                  Text(tag.tag, style: TextStyle(fontWeight: FontWeight.bold)),
                  // SizedBox(width: 12),
                  // Text(word, style: TextStyle(fontSize: 12.0)),
                ]),
            trailing: Text("0個の単語"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider.value(
                    value: TaggedWordListViewModel(tag: tag),
                    child: TaggedWordList());
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
}
