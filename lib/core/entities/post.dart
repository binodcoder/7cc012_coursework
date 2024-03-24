class Post {
  int? id;
  String title;
  String content;
  String? imagePath;
  int isSelected;
  DateTime? createdAt;

  Post({
    this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.isSelected,
    this.createdAt,
  });
}
