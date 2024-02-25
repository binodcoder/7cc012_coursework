import 'package:my_blog_bloc/core/entities/post.dart';

class PostModel extends Post {
  PostModel(
    String id,
    String title,
    String content,
    String imagePath,
    int isSelected,
  ) : super(
          id,
          title,
          content,
          imagePath,
          isSelected,
        );

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
