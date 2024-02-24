import 'package:flutter/material.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../domain/entities/post.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({
    Key? key,
    this.post,
  }) : super(key: key);

  final Post? post;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: ColorManager.primary,
          ),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: Text(
          'Post Details',
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(
              height: AppHeight.h10,
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              tileColor: ColorManager.white,
              title: Text(
                widget.post!.title,
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                widget.post!.title,
                style: const TextStyle(fontSize: FontSize.s14),
              ),
            ),
            SizedBox(
              height: AppHeight.h20,
            ),
            SizedBox(
              height: AppHeight.h20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '',
                style: TextStyle(fontSize: FontSize.s12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
