import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:romney/entities/tag.dart';
import 'package:romney/entities/tag_with_nwords.dart';
import 'package:romney/ui/pages/words/taggedList.dart';
import 'package:romney/viewmodels/words/taggedList.dart';

import 'package:romney/viewmodels/tags/list.dart';
import 'package:romney/viewmodels/tags/listItem.dart';

enum DeleteConfirmOption {
  Delete,
  Cancel,
}

class ListItem extends StatelessWidget {
  final TagWithNwords tagWithNwords;

  ListItem({this.tagWithNwords});

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
                  Text(tagWithNwords.tag,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  // SizedBox(width: 12),
                  // Text(word, style: TextStyle(fontSize: 12.0)),
                ]),
            trailing: Text("${tagWithNwords.nwords}個の単語"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChangeNotifierProvider.value(
                    value: TaggedWordListViewModel(tag: tagWithNwords),
                    child: TaggedWordList(Tag(tag: tagWithNwords.tag)));
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
    final tagListItemVM = context.read<TagListItemViewModel>();
    final tagListVM = context.read<TagListViewModel>();
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
        tagListItemVM.delete();
        tagListVM.deleteOne(tagListItemVM.tag);
        print("Delete");
        break;
      case DeleteConfirmOption.Cancel:
        print("Cancel");
        break;
    }
  }
}
