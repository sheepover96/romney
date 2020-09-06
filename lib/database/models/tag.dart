import 'package:romney/entities/tag.dart' as gTag;

class Tag {
  final int id;
  final String tag;
  final String createdAt;

  Tag({
    this.id,
    this.tag,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'created_at': createdAt,
    };
  }

  static gTag.Tag fromMap(Map<String, dynamic> tagMap) {
    return gTag.Tag(
        id: tagMap['id'],
        tag: tagMap['tag'],
        createdAt: DateTime.parse(tagMap['created_at']));
  }
}
