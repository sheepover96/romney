import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:romney/entities/tag.dart';
import 'package:romney/ui/pages/tags/add.dart' as tagAdd;
import 'package:romney/ui/pages/tags/listItem.dart' as tagItem;
import 'package:romney/viewmodels/tags/list.dart';

class TagList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tagListViewModel = context.watch<TagListViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Tag List')),
      body: FutureBuilder(
          future: tagListViewModel.fetchTags(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListView.builder(
                itemCount: tagListViewModel.getList().length,
                itemBuilder: (context, index) {
                  return _buildItem(tagListViewModel.getOne(index));
                });
            // return _buildItemList();
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Container(
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.orangeAccent,
        // Icon(Icons.add),
        onPressed: () async {
          final newTag = await Navigator.of(context).push(_createRoute());
          tagListViewModel.addTags(newTag);
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
        // var end = Offset(0.0, 0.1);
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

  Widget _buildItem(Tag tag) {
    return tagItem.ListItem(tag: tag);
  }
}
