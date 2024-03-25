import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_blog_bloc/core/entities/post.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/values_manager.dart';

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
          onPressed: () {
            Navigator.pop(context);
          },
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
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: widget.post!.imagePath == null
                  ? Image.asset('assets/images/noimage.jpg')
                  : Image.file(
                      File(widget.post!.imagePath!),
                    ),
            ),
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
                widget.post!.content,
                style: const TextStyle(fontSize: FontSize.s14),
              ),
              trailing: IconButton(
                onPressed: () async {
                  widget.post!.imagePath != null
                      ? await Share.shareXFiles(
                          [XFile(widget.post!.imagePath!)],
                          text: widget.post!.content,
                          subject: widget.post!.title,
                        )
                      : Share.share(widget.post!.content, subject: widget.post!.title);
                },
                icon: const Icon(Icons.share),
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
