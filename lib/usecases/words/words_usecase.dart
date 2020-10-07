import 'package:romney/entities/tag.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/repositories/words/words_repository_if.dart';
import 'package:romney/usecases/words/words_usecase_if.dart';

class WordsUsecase implements IWordsUsecase {
  static WordsUsecase _singleton;
  final IWordsRepository wordsRepository;

  factory WordsUsecase({IWordsRepository wordsRepository}) {
    if (_singleton == null)
      _singleton = WordsUsecase._internal(wordsRepository);
    return _singleton;
  }

  WordsUsecase._internal(this.wordsRepository);

  Future insert(Word word) async {
    await wordsRepository.insert(word);
    return Future.value("succeed");
  }

  Future delete(Word word) async {
    await wordsRepository.delete(word);
    return Future.value("succeed");
  }

  Future update() async {}

  Future getOne() async {}

  Future getList() async {
    final res = await wordsRepository.getList();
    return res;
  }

  Future getWordListWithTag() async {
    final res = await wordsRepository.getWordListWithTag();
    return res;
  }

  Future getTaggedWordList(Tag tag) async {
    final res = await wordsRepository.getTaggedList(tag);
    return res;
  }

  Future getTaggedWordListWithTag(Tag tag) async {
    final res = await wordsRepository.getTaggedListWithTag(tag);
    return res;
  }

  Future updateIsFavorite(Word word) async {
    await wordsRepository.updateIsFavorite(word);
  }
}
