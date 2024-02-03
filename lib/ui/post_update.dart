import 'package:flutter/material.dart';
import '../model/post_model.dart';

class EditPostDialog extends StatelessWidget {
  final Post post;
  final Function(Post) onEdit;

  const EditPostDialog({
    required this.post,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text: post.title);
    final TextEditingController contentController = TextEditingController(text: post.content);
    final TextEditingController imageController = TextEditingController(text: post.imageUrl);

    return AlertDialog(
      title: Text('Edit Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
          TextField(
            controller: imageController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            var updatedPost = Post(
              post.id,
              titleController.text,
              contentController.text,
              imageController.text,
            );
            onEdit(updatedPost);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
