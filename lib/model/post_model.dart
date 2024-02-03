class Post {
  final String id; // Unique identifier for each post
  String title;
  String content;
  String imageUrl;

  Post(this.id, this.title, this.content, this.imageUrl);

  // Convert Post object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
