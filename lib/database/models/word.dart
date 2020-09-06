import 'package:flutter/material.dart';

import 'package:romney/entities/word.dart' as gWord;

class Word {
  final int id;
  final String word;
  final String reading;
  final String meaning;
  final int isFavorite;
  final int isInDictionary;
  final String createdAt;

  Word({
    this.id,
    @required this.word,
    this.reading,
    this.meaning,
    this.createdAt,
    this.isFavorite = 0,
    this.isInDictionary = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
      'is_favorite': isFavorite,
      'is_in_dictionary': isInDictionary,
      'created_at': createdAt,
    };
  }

  static gWord.Word fromMap(Map<String, dynamic> wordMap) {
    return gWord.Word(
      id: wordMap['id'],
      word: wordMap['word'],
      reading: wordMap['reading'],
      meaning: wordMap['meaning'],
      isFavorite: (wordMap['is_favorite'] == 1) ? true : false,
      isInDictionary: (wordMap['is_in_dictionary'] == 1) ? true : false,
      createdAt: DateTime.parse(wordMap['created_at']),
    );
  }
}
