import 'package:romney/entities/word.dart';

abstract class IWordListViewModel {
  List getList();

  Word getOne(int index);

  Future deleteOne(Word word);

  Future addWord(String newWord);
}
