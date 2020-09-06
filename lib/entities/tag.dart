class Tag {
  final int id;
  final String tag;
  final DateTime createdAt;

  Tag({
    this.id,
    this.tag,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tag': tag,
      'createdAt': createdAt,
    };
  }
}
