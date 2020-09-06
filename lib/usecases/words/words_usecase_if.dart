import 'package:romney/entities/word.dart';
import 'package:romney/entities/tag.dart';

abstract class IWordsUsecase {
  Future insert(Word word);

  Future update();

  Future getOne();

  Future getList();

  Future getWordListWithTag();

  Future getTaggedWordList(Tag tag);

  Future getTaggedWordListWithTag(Tag tag);

  Future updateIsFavorite(Word word);
}
