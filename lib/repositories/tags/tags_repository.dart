import 'package:sqflite/sql.dart';

import 'package:romney/database/database.dart' as db;
import 'package:romney/database/models/tag.dart' as dbTag;
import 'package:romney/entities/tag.dart';
import 'package:romney/repositories/tags/tags_repository_if.dart';

class TagsRepository implements ITagsRepository {
  final db.DBProvider dbProvider;

  TagsRepository({this.dbProvider});

  Future insert(Tag tag) async {
    final newTag = dbTag.Tag(tag: tag.tag, createdAt: tag.createdAt.toString());
    try {
      await dbProvider.db.insert("tags", newTag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (e) {
      print(e);
    }
  }

  Future update() async {}

  Future getOne() async {}

  Future getList() async {
    try {
      List<Tag> tagList = List();
      final res = await dbProvider.db.query("tags");
      // print(res);
      res.forEach((Map<String, dynamic> tagMap) {
        final newTag = dbTag.Tag.fromMap(tagMap);
        tagList.add(newTag);
      });
      return tagList;
    } catch (e) {
      print(e);
    }
  }

  Future getListWithWordCount() async {
    try {
      final res = await dbProvider.db.rawQuery("""
        select * from tags inner join (
          select tag_id, count(word_id) from word_tags
          group by tag_id;
        ) as word_count
        on tags.id = word_count.tag_id
      """);
      return res;
    } catch (e) {
      print(e);
    }
  }
}
