import 'package:romney/entities/tag.dart';

abstract class ITagsRepository {
  Future insert(Tag tag);

  Future update();

  Future getOne();

  Future getList();

  Future getListWithWordCount();
}
