import 'package:romney/entities/tag.dart';

class TagWithNwords extends Tag {
  final int id;
  final String tag;
  final DateTime createdAt;
  final int nwords;

  TagWithNwords({this.id, this.tag, this.createdAt, this.nwords});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'nwords': nwords,
      'createdAt': createdAt,
    };
  }
}
