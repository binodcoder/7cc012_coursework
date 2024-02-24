class PostModel {
  final String id;
  String title;
  String content;
  String imagePath;
  int isSelected;

  PostModel(this.id, this.title, this.content, this.imagePath, this.isSelected);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'isSelected': isSelected,
    };
  }
}
