import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_blog_bloc/core/entities/post.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/colour_manager.dart';
import '../../../../resources/font_manager.dart';

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
    Size size = MediaQuery.of(context).size;

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
        elevation: 2,
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
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              tileColor: ColorManager.white,
              title: Text(
                widget.post!.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Column(
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: size.width,
                        height: size.height * 0.3,
                        child: widget.post!.imagePath == null
                            ? Image.asset(
                                'assets/images/noimage.jpg',
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(widget.post!.imagePath!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    widget.post!.content,
                    style: const TextStyle(fontSize: FontSize.s14),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  widget.post!.imagePath != null
                      ? await Share.shareXFiles(
                          [XFile(widget.post!.imagePath!)],
                          text: widget.post!.content,
                          subject: widget.post!.title,
                        )
                      : Share.share(widget.post!.content, subject: widget.post!.title);
                },
                child: SizedBox(
                  width: size.width * 0.2,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Share"),
                      Icon(Icons.share),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
