import 'package:sqflite/sql.dart';

import 'package:romney/database/database.dart' as db;
import 'package:romney/database/models/tag.dart' as dbTag;
import 'package:romney/entities/tag.dart';
import 'package:romney/entities/tag_with_nwords.dart';
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

  Future delete(Tag tag) async {
    try {
      dbProvider.db.delete("tags", where: "id=?", whereArgs: [tag.id]);
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

  Future getListWithNWords() async {
    try {
      List<TagWithNwords> tagList = List();
      final res = await dbProvider.db.rawQuery("""
        SELECT * FROM tags LEFT OUTER JOIN (
          SELECT tag_id, count(word_id) AS nwords FROM word_tags
          GROUP BY tag_id
        ) AS RES1 ON tags.id = RES1.tag_id
      """);
      res.forEach((Map<String, dynamic> tagMap) {
        final newTagWithNWords = TagWithNwords(
          id: tagMap['id'],
          tag: tagMap['tag'],
          nwords: tagMap['nwords'] != null ? tagMap['nwords'] : 0,
          createdAt: DateTime.parse(tagMap['created_at']),
        );
        tagList.add(newTagWithNWords);
      });
      return tagList;
    } catch (e) {
      print(e);
    }
  }
}
