import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import 'package:my_blog_bloc/ui/post_add.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../db/db_helper.dart';
import '../model/post_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    var postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddPost(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text(AppStrings.titleLabel),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return FutureBuilder<List<Post>>(
            future: dbHelper.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${AppStrings.error}: ${snapshot.error}');
              } else {
                var posts = snapshot.data as List<Post>;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.content),
                          if (post.imageUrl.isNotEmpty)
                            Image.network(
                              post.imageUrl,
                              height: 100,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => AddPost(
                                        post: post,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: const Text(AppStrings.edit),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbHelper.deletePost(post.id);
                                  postBloc.add(DeletePostEvent(post.id));
                                },
                                child: const Text(AppStrings.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );  
  }

  // Function to navigate to Edit Screen
//   void _navigateToEditScreen(BuildContext context, Post post) {
//     titleController.text = post.title;
//     contentController.text = post.content;
//     imageController.text = post.imageUrl;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(AppStrings.editPost),
//           content: Column(
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: AppStrings.title),
//               ),
//               TextField(
//                 controller: contentController,
//                 decoration: const InputDecoration(labelText: AppStrings.content),
//               ),
//               TextField(
//                 controller: imageController,
//                 decoration: const InputDecoration(labelText: AppStrings.imageURL),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text(AppStrings.cancel),
//             ),
//             TextButton(
//               onPressed: () async {
//                 var updatedPost = Post(
//                   post.id,
//                   titleController.text,
//                   contentController.text,
//                   imageController.text,
//                 );

//                 // Update post in local database
//                 await dbHelper.updatePost(updatedPost);

//                 // Update post in BLoC state

//                 BlocProvider.of<PostBloc>(context).add(UpdatePostEvent(updatedPost));

//                 titleController.clear();
//                 contentController.clear();
//                 imageController.clear();
//                 Navigator.pop(context);
//               },
//               child: const Text(AppStrings.save),
//             ),
//           ],
//         );
//       },
//     );
//   }
}
