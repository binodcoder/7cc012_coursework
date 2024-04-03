import '../entities/post.dart';

class PostModel extends Post {
  PostModel({
    int? id,
    required String title,
    required String content,
    String? imagePath,
    required int isSelected,
    DateTime? createdAt,
  }) : super(
          id: id,
          title: title,
          content: content,
          imagePath: imagePath,
          isSelected: isSelected,
          createdAt: createdAt,
        );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'isSelected': isSelected,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        imagePath: json["imagePath"],
        isSelected: json["isSelected"],
        createdAt: json["createdAt"],
      );
}
