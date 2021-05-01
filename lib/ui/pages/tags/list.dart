import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:romney/entities/tag.dart';
import 'package:romney/entities/tag_with_nwords.dart';
import 'package:romney/ui/pages/tags/add.dart' as tagAdd;
import 'package:romney/ui/pages/tags/listItem.dart' as tagItem;
import 'package:romney/ui/pages/words/favoriteList.dart';
import 'package:romney/viewmodels/tags/list.dart';
import 'package:romney/viewmodels/tags/listItem.dart';

class TagList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tagListViewModel = context.watch<TagListViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Tag List')),
      body: FutureBuilder(
          future: Future.wait([
            tagListViewModel.fetchTags(),
            tagListViewModel.fetchNFavorite(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            List<Widget> list = [_favoriteItem(tagListViewModel.nFavorite)];
            tagListViewModel.getList().asMap().forEach((i, e) {
              list.add(_buildItem(e as TagWithNwords));
            });
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return list[index];
                });
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Container(
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.orangeAccent,
        onPressed: () async {
          final newTag = await Navigator.of(context).push(_createRoute());
          tagListViewModel.addTag(newTag);
          // _openDialog(context);
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      // pageBuilder: (context, animation, secondaryAnimation) => MyForm(),
      pageBuilder: (context, animation, secondaryAnimation) => tagAdd.Add(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.8);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      fullscreenDialog: true,
    );
  }

  Widget _favoriteItem(int nFavorite) {
    return tagItem.BookmarkItem(nFavorite: nFavorite);
  }

  Widget _buildItem(TagWithNwords tagWithNwords) {
    return ChangeNotifierProvider<TagListItemViewModel>.value(
      value: TagListItemViewModel(tag: tagWithNwords),
      child: tagItem.ListItem(tagWithNwords: tagWithNwords),
    );
  }
}
