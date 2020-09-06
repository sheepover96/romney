import 'package:romney/entities/tag.dart';

class Word {
  int id;
  String word;
  String reading;
  String meaning;
  Tag tag;
  bool isFavorite;
  bool isInDictionary;
  DateTime createdAt;

  Word({
    this.id,
    this.word,
    this.reading,
    this.meaning,
    this.tag,
    this.createdAt,
    this.isFavorite = false,
    this.isInDictionary = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
      'tag': tag,
      'isFavorite': isFavorite,
      'isInDictionary': isInDictionary,
      'createdAt': createdAt,
    };
  }

  Word fromMap(Map<String, dynamic> wordMap) {}
}
