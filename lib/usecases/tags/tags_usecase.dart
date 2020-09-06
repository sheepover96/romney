import 'package:romney/usecases/tags/tags_usecase_if.dart';
import 'package:romney/repositories/tags/tags_repository.dart';
import 'package:romney/entities/tag.dart';

class TagsUsecase implements ITagsUsecase {
  static TagsUsecase _singleton;
  final TagsRepository tagsRepository;

  factory TagsUsecase({TagsRepository tagsRepository = null}) {
    if (_singleton == null) {
      _singleton = TagsUsecase._internal(tagsRepository);
    }
    return _singleton;
  }

  TagsUsecase._internal(this.tagsRepository);

  Future insert(Tag tag) async {
    await tagsRepository.insert(tag);
    return Future.value("succeed");
  }

  Future update() async {}

  Future getOne() async {}

  Future<List> getList() async {
    final res = await tagsRepository.getList();
    return res;
  }

  Future getListWithWordCount() async {}
}
