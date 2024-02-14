class Post {
  final String id; // Unique identifier for each post
  String title;
  String content;
  String imageUrl;
  int isSelected;

  Post(this.id, this.title, this.content, this.imageUrl, this.isSelected);

  // Convert Post object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'isSelected': isSelected,
    };
  }
}
