import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_blog_bloc/resources/colour_manager.dart';
import 'package:my_blog_bloc/resources/font_manager.dart';
import 'package:my_blog_bloc/resources/strings_manager.dart';
import '../../../../core/db/db_helper.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../../../add_post/presentation/ui/post_add.dart';
import 'post_details.dart';
import '../../../../injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  TextEditingController searchMenuController = TextEditingController();

  // Widget _imageDisplay(String? imagePath, Size size) {
  //   return Container(
  //     width: size.width,
  //     height: size.height * 0.3,
  //     decoration: BoxDecoration(
  //       border: Border.all(),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: FittedBox(
  //       fit: BoxFit.fill,
  //       child: imagePath == null
  //           ? Image.asset(
  //               'assets/images/noimage.jpg',
  //             )
  //           : Image.file(
  //               File(imagePath),
  //             ),
  //     ),
  //   );
  // }

  Widget _imageDisplay(String? imagePath, Size size) {
    return Container(
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
          child: imagePath == null
              ? Image.asset(
                  'assets/images/noimage.jpg',
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    postBloc.add(PostInitialEvent());
    super.initState();
  }

  void refreshPage() {
    postBloc.add(PostInitialEvent());
  }

  PostBloc postBloc = sl<PostBloc>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<PostBloc, PostState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is PostActionState,
      buildWhen: (previous, current) => current is! PostActionState,
      listener: (context, state) {
        if (state is PostNavigateToAddPostActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddPost(),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is PostNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddPost(
                post: state.post,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is PostNavigateToUpdatePageActionState) {
        } else if (state is PostItemSelectedActionState) {
        } else if (state is PostItemDeletedActionState) {
        } else if (state is PostItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case PostLoadingState:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          case PostLoadedSuccessState:
            final successState = state as PostLoadedSuccessState;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
                onPressed: () {
                  postBloc.add(PostAddButtonClickedEvent());
                },
              ),
              appBar: AppBar(
                iconTheme: IconThemeData(color: ColorManager.primary),
                elevation: 2,
                backgroundColor: ColorManager.white,
                title: state.isSearch
                    ? TextField(
                        autofocus: true,
                        controller: searchMenuController,
                        style: TextStyle(color: ColorManager.primary),
                        decoration: InputDecoration(
                          fillColor: ColorManager.primary,
                          hintText: 'Search',
                          focusColor: ColorManager.primary,
                          hintStyle: TextStyle(
                            color: ColorManager.primary,
                          ),
                        ),
                        onChanged: (value) => postBloc.add(PostSearchIconClickedEvent(value, true)),
                      )
                    : Text(
                        'Posts',
                        style: TextStyle(color: ColorManager.primary, fontWeight: FontWeight.bold),
                      ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (postBloc.selectedPosts.isEmpty) {
                        postBloc.add(PostSearchIconClickedEvent("", !state.isSearch));
                        searchMenuController.clear();
                      } else {
                        postBloc.add(PostDeleteAllButtonClickedEvent());
                        Future.delayed(const Duration(microseconds: 1000), () {
                          postBloc.selectedPosts = [];
                        });
                      }
                    },
                    icon: FaIcon(
                      postBloc.selectedPosts.isEmpty
                          ? state.isSearch == false
                              ? FontAwesomeIcons.magnifyingGlass
                              : FontAwesomeIcons.xmark
                          : FontAwesomeIcons.xmark,
                      color: ColorManager.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: successState.postList.length,
                itemBuilder: (context, index) {
                  var postModel = successState.postList[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.darkPrimary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: postModel.isSelected == 0 ? ColorManager.white : ColorManager.lightGrey,
                      onLongPress: () async {
                        postBloc.add(PostTileLongPressEvent(postModel));
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PostDetailsPage(
                              post: postModel,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        postModel.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: FontSize.s20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          _imageDisplay(postModel.imagePath, size),
                          Text(postModel.content),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: size.width * 0.63,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        postBloc.add(PostTileNavigateEvent(postModel));
                                      },
                                      child: const Text(AppStrings.edit),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        postBloc.add(PostDeleteButtonClickedEvent(postModel));
                                      },
                                      child: const Text(AppStrings.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          case PostErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
