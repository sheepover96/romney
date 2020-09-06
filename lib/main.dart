import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:romney/database/database.dart' as db;
import 'package:romney/ui/pages/home.dart' as mainPage;

import 'package:romney/repositories/words/words_repository.dart';
import 'package:romney/usecases/words/words_usecase.dart';

import 'package:romney/repositories/tags/tags_repository.dart';
import 'package:romney/usecases/tags/tags_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbProvider = new db.DBProvider();
  await dbProvider.init();

  final wordsRepo = WordsRepository(dbProvider: dbProvider);
  WordsUsecase(wordsRepository: wordsRepo);

  final tagsRepo = TagsRepository(dbProvider: dbProvider);
  TagsUsecase(tagsRepository: tagsRepo);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Romney',
      theme: ThemeData(
        fontFamily: "MPLUS1",
        primaryColor: Colors.orange,
      ),
      home: mainPage.MainPage()
      // MultiProvider(
      //   providers: [Provider<WordsUsecase>.value(value: wordsUsecase)],
      //   child: mainPage.MainPage(),
      // )
      ));
}

// void init() async {
//   final dbProvider = new db.DBProvider();
//   await dbProvider.init();
//
//   final wordsRepo = WordsRepository(dbProvider: db.DBClient);
//   final wordsUsecase = WordsUsecase(wordsRepository: wordsRepo);
// }
