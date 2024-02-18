class Post {
  final String id; // Unique identifier for each post
  String title;
  String content;
  String imagePath;
  int isSelected;

  Post(this.id, this.title, this.content, this.imagePath, this.isSelected);

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
