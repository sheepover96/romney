import 'package:romney/entities/tag.dart';

abstract class ITagsUsecase {
  Future insert(Tag tag);

  Future update();

  Future getOne();

  Future<List> getList();

  Future getListWithWordCount();
}
