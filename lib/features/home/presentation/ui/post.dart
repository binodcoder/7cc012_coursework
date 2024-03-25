import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_blog_bloc/resources/colour_manager.dart';
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

  Widget _imageDisplay(String? imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: imagePath == null
          ? Image.asset('assets/images/noimage.jpg')
          : Image.file(
              File(imagePath),
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
                elevation: 0,
                backgroundColor: ColorManager.white,
                //        title: Obx(() => menuListController.isSearch.value
                // ?

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
                // title: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(AppStrings.titleLabel),
                //     TextButton(
                //       onPressed: () async {
                //         postBloc.add(PostDeleteAllButtonClickedEvent());
                //       },
                //       child: Text(
                //         'Delete',
                //         style: TextStyle(
                //           color: ColorManager.white,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                actions: [
                  IconButton(
                    onPressed: () {
                      postBloc.add(PostSearchIconClickedEvent("", !state.isSearch));
                      searchMenuController.clear();
                    },
                    icon: FaIcon(
                      state.isSearch == false ? FontAwesomeIcons.magnifyingGlass : FontAwesomeIcons.xmark,
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
                  return ListTile(
                    tileColor: postModel.isSelected == 0 ? ColorManager.white : ColorManager.grey,
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
                    title: Text(postModel.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(postModel.content),
                        _imageDisplay(postModel.imagePath),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                postBloc.add(PostTileNavigateEvent(postModel));
                              },
                              child: const Text(AppStrings.edit),
                            ),
                            TextButton(
                              onPressed: () {
                                postBloc.add(PostDeleteButtonClickedEvent(postModel));
                              },
                              child: const Text(AppStrings.delete),
                            ),
                          ],
                        ),
                      ],
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
