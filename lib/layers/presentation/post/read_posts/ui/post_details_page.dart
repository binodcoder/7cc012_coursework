import 'package:blog_app/layers/presentation/widgets.dart/custom_button.dart';
import 'package:blog_app/layers/presentation/widgets.dart/image_frame.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/entities/post.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/strings_manager.dart';
import '../../../../../resources/values_manager.dart';

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
          AppStrings.postDetails,
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(AppSize.s4),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 185, 223, 254),
              Color(0xFF90CAF9),
              Color(0xFFBBDEFB),
              Color(0xFFE3F2FD),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 1.0],
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSize.s10),
            child: ListView(
              children: [
                Text(
                  widget.post!.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  tileColor: ColorManager.white,
                  subtitle: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      widget.post!.imagePath == null
                          ? const SizedBox()
                          : ImageFrame(
                              size: size,
                              imagePath: widget.post!.imagePath,
                            ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        widget.post!.content,
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          DateFormat.yMEd().add_jm().format(widget.post!.createdAt!),
                          style: TextStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: () async {
                      widget.post!.imagePath != null
                          ? await Share.shareXFiles(
                              [XFile(widget.post!.imagePath!)],
                              text: widget.post!.content,
                              subject: widget.post!.title,
                            )
                          : Share.share(
                              widget.post!.content,
                              subject: widget.post!.title,
                            );
                    },
                    child: SizedBox(
                      width: size.width * 0.2,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.share),
                          Icon(Icons.share),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
