import 'dart:io';
import 'package:blog_app/layers/presentation/widgets.dart/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../add_update_post/ui/create_post_page.dart';
import '../bloc/read_posts_bloc.dart';
import '../bloc/read_posts_event.dart';
import '../bloc/read_posts_state.dart';
import 'post_details_page.dart';

class ReadPostsPage extends StatefulWidget {
  const ReadPostsPage({super.key});

  @override
  State<ReadPostsPage> createState() => _ReadPostsPageState();
}

class _ReadPostsPageState extends State<ReadPostsPage> {
  TextEditingController searchMenuController = TextEditingController();

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

  ReadPostsBloc postBloc = sl<ReadPostsBloc>();
  SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<ReadPostsBloc, ReadPostsState>(
      bloc: postBloc,
      listenWhen: (previous, current) => current is PostActionState,
      buildWhen: (previous, current) => current is! PostActionState,
      listener: (context, state) {
        if (state is PostNavigateToAddPostActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CreatePostPage(),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is PostNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreatePostPage(
                post: state.post,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is PostNavigateToUpdatePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreatePostPage(post: state.post),
              fullscreenDialog: true,
            ),
          ).then((value) => refreshPage());
        } else if (state is PostItemSelectedActionState) {
        } else if (state is PostItemDeletedActionState) {
          postBloc.add(PostInitialEvent());
        } else if (state is PostItemsDeletedActionState) {
          postBloc.add(PostInitialEvent());
        } else if (state is PostItemsUpdatedState) {
          postBloc.add(PostInitialEvent());
        }
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
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true, // Extend gradient behind app bar
              extendBody: true,
              drawer: const MyDrawer(),
              floatingActionButton: sharedPreferences.getString("role") == "admin"
                  ? FloatingActionButton(
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        postBloc.add(PostAddButtonClickedEvent());
                      },
                    )
                  : null,
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF64B5F6), // Light blue
                        Color.fromRGBO(235, 242, 249, 1), // Sky blue
                        Color.fromARGB(255, 235, 241, 246), // Pale blue
                        Color.fromARGB(255, 154, 208, 247), // Very pale blue
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
                iconTheme: IconThemeData(color: ColorManager.primary),
                // elevation: 2,
                // backgroundColor: ColorManager.white,
                title: successState.isSearch
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        width: size.width,
                        height: size.height * 0.054,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorManager.grey), // Set border color to white
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: searchMenuController,
                          style: TextStyle(color: ColorManager.primary),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: ColorManager.primary,
                            hintText: 'Search',
                            focusColor: ColorManager.primary,
                            hintStyle: TextStyle(
                              color: ColorManager.primary,
                            ),
                          ),
                          onChanged: (value) => postBloc.add(PostSearchIconClickedEvent(value, true)),
                        ),
                      )
                    : Text(
                        'Posts',
                        style: TextStyle(color: ColorManager.primary, fontWeight: FontWeight.bold),
                      ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (successState.selectedPosts.isEmpty) {
                        postBloc.add(PostSearchIconClickedEvent("", !successState.isSearch));
                        searchMenuController.clear();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Expanded(
                              child: AlertDialog(
                                title: Text('Delete'),
                                content: Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      postBloc.add(PostDeleteAllButtonClickedEvent());
                                      Future.delayed(const Duration(microseconds: 1000), () {
                                        postBloc.selectedPosts = [];
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('ACCEPT'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    icon: FaIcon(
                      successState.selectedPosts.isEmpty
                          ? state.isSearch == false
                              ? FontAwesomeIcons.magnifyingGlass
                              : FontAwesomeIcons.xmark
                          : sharedPreferences.getString("role") == "admin"
                              ? FontAwesomeIcons.trash
                              : null,
                      color: successState.selectedPosts.isEmpty
                          ? state.isSearch == false
                              ? ColorManager.primary
                              : ColorManager.darkGrey
                          : ColorManager.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 185, 223, 254), // Light blue
                      Color(0xFF90CAF9), // Sky blue
                      Color(0xFFBBDEFB), // Pale blue
                      Color(0xFFE3F2FD), // Very pale blue
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4, 0.7, 1.0],
                  ),
                ),
                child: ListView.builder(
                  itemCount: successState.postList.length,
                  itemBuilder: (context, index) {
                    var postModel = successState.postList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: const EdgeInsets.all(15),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: postModel.isSelected == 0 ? ColorManager.white : ColorManager.lightGrey,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(15),
                        child: Slidable(
                          enabled: sharedPreferences.getString("role") == "admin" ? true : false,
                          endActionPane: ActionPane(
                            extentRatio: 0.60,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  postBloc.add(PostEditButtonClickedEvent(postModel));
                                },
                                backgroundColor: Color.fromARGB(255, 113, 205, 217),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  postBloc.add(PostDeleteButtonClickedEvent(postModel));
                                },
                                backgroundColor: Color.fromARGB(255, 201, 32, 46),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            ],
                          ),
                          child: ListTile(
                            onLongPress: () async {
                              if (sharedPreferences.getString("role") == "admin") {
                                postBloc.add(PostTileLongPressEvent(postModel));
                              }
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
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  postModel.title.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: FontSize.s20,
                                  ),
                                ),
                                postModel.isSelected == 0
                                    ? const SizedBox()
                                    : Icon(
                                        Icons.check_circle,
                                        color: ColorManager.darkGreen,
                                      ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                postModel.imagePath != null ? _imageDisplay(postModel.imagePath, size) : const SizedBox(),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text(postModel.content),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
