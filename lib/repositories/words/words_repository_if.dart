import 'package:romney/entities/word.dart';
import 'package:romney/entities/tag.dart';

abstract class IWordsRepository {
  Future insert(Word word);

  Future update();

  Future getOne();

  Future<List<Word>> getList();

  Future<List<Word>> getWordListWithTag();

  Future<List<Word>> getTaggedList(Tag tag);

  Future<List<Word>> getTaggedListWithTag(Tag tag);

  Future updateIsFavorite(Word word);
}
