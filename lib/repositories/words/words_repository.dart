import 'package:sqflite/sql.dart';

import 'package:romney/database/database.dart' as db;
import 'package:romney/database/models/word.dart' as dbWord;
import 'package:romney/entities/tag.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/repositories/words/words_repository_if.dart';

class WordsRepository implements IWordsRepository {
  final db.DBProvider dbProvider;

  WordsRepository({this.dbProvider});

  Future insert(Word word) async {
    final newWord = dbWord.Word(
        word: word.word,
        meaning: word.meaning,
        reading: word.reading,
        isInDictionary: word.isInDictionary ? 1 : 0,
        createdAt: word.createdAt.toString());
    try {
      dbProvider.db.transaction((txn) async {
        final newWordID = await txn.insert("words", newWord.toMap(),
            conflictAlgorithm: ConflictAlgorithm.fail);
        if (word.tag != null) {
          await txn.insert(
              "word_tags",
              {
                "word_id": newWordID,
                "tag_id": word.tag.id,
              },
              conflictAlgorithm: ConflictAlgorithm.fail);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future delete(Word word) async {
    try {
      print("before delete");
      dbProvider.db.delete("words", where: "id=?", whereArgs: [word.id]);
    } catch (e) {
      print(e);
    }
  }

  Future update() async {}

  Future getOne() async {}

  Future<List<Word>> getList() async {
    try {
      List<Word> wordList = List();
      final res = await dbProvider.db.query("words");
      res.forEach((Map<String, dynamic> wordMap) {
        final word = dbWord.Word.fromMap(wordMap);
        wordList.add(Word(
          id: word.id,
          word: word.word,
          meaning: word.meaning,
          reading: word.reading,
          isFavorite: word.isFavorite ? true : false,
          isInDictionary: word.isInDictionary ? true : false,
        ));
      });
      return Future.value(wordList);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Word>> getWordListWithTag() async {
    try {
      List<Word> wordList = List();
      final res = await dbProvider.db.rawQuery("""
      SELECT * FROM words LEFT OUTER JOIN (
        SELECT word_tags.word_id, word_tags.tag_id, tags.tag as tag,
        tags.created_at as tag_created_at
        FROM tags LEFT OUTER JOIN word_tags
        ON word_tags.tag_id = tags.id
      ) as RES1 ON words.id = RES1.word_id
      """);
      res.forEach((Map<String, dynamic> wordMap) {
        final word = dbWord.Word.fromMap(wordMap);
        Tag tag;
        if (wordMap["tag"] != null) {
          tag = Tag(
              id: wordMap["tag_id"],
              tag: wordMap["tag"],
              createdAt: DateTime.parse(wordMap["tag_created_at"]));
        }
        wordList.add(Word(
          id: word.id,
          word: word.word,
          meaning: word.meaning,
          reading: word.reading,
          tag: tag,
          isFavorite: word.isFavorite ? true : false,
          isInDictionary: word.isInDictionary ? true : false,
        ));
      });
      return Future.value(wordList);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Word>> getTaggedList(Tag tag) async {
    try {
      List<Word> wordList = List();
      final res = await dbProvider.db.rawQuery("""
      SELECT * from words
      INNER JOIN word_tags on words.id = word_tags.word_id
      where word_tags.tag_id = ?
      """, [tag.id]);
      res.forEach((Map<String, dynamic> wordMap) {
        final word = dbWord.Word.fromMap(wordMap);
        wordList.add(Word(
          id: word.id,
          word: word.word,
          meaning: word.meaning,
          reading: word.reading,
          isFavorite: word.isFavorite ? true : false,
          isInDictionary: word.isInDictionary ? true : false,
        ));
      });
      return Future.value(wordList);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<Word>> getTaggedListWithTag(Tag tag) async {
    try {
      List<Word> wordList = List();
      final res = await dbProvider.db.rawQuery("""
      SELECT * FROM words INNER JOIN (
        SELECT word_tags.word_id, word_tags.tag_id, tags.tag as tag,
        tags.created_at as tag_created_at
        FROM tags INNER JOIN word_tags
        ON word_tags.tag_id = tags.id
        where tags.id = ?
      ) as RES1 ON words.id = RES1.word_id
      """, [tag.id]);
      res.forEach((Map<String, dynamic> wordMap) {
        final word = dbWord.Word.fromMap(wordMap);
        Tag tag;
        if (wordMap["tag"] != null) {
          tag = Tag(
              id: wordMap["tag_id"],
              tag: wordMap["tag"],
              createdAt: DateTime.parse(wordMap["tag_created_at"]));
        }
        wordList.add(Word(
          id: word.id,
          word: word.word,
          tag: tag,
          meaning: word.meaning,
          reading: word.reading,
          isFavorite: word.isFavorite ? true : false,
          isInDictionary: word.isInDictionary ? true : false,
        ));
      });
      return Future.value(wordList);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future updateIsFavorite(Word word) async {
    try {
      await dbProvider.db.update(
          "words", {"is_favorite": word.isFavorite ? 0 : 1},
          where: "id = ?", whereArgs: [word.id]);
      return Future.value("success");
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
