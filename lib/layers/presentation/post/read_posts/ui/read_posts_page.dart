import 'package:blog_app/layers/presentation/widgets.dart/drawer.dart';
import 'package:blog_app/layers/presentation/widgets.dart/image_frame.dart';
import 'package:blog_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/styles_manager.dart';
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
              extendBodyBehindAppBar: true,
              extendBody: true,
              drawer: const MyDrawer(),
              floatingActionButton: sharedPreferences.getString("role") == "admin"
                  ? FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        postBloc.add(PostAddButtonClickedEvent());
                      },
                    )
                  : null,
              appBar: AppBar(
                title: successState.isSearch
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        width: size.width,
                        height: size.height * 0.054,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorManager.primary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: searchMenuController,
                          style: getBoldStyle(color: ColorManager.primary),
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            fillColor: ColorManager.primary,
                            hintText: AppStrings.search,
                            focusColor: ColorManager.primary,
                            hintStyle: getRegularStyle(color: ColorManager.primary),
                          ),
                          onChanged: (value) => postBloc.add(PostSearchIconClickedEvent(value, true)),
                        ),
                      )
                    : const Text(
                        AppStrings.post,
                      ),
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
                            return AlertDialog(
                              title: const Text(AppStrings.delete),
                              content: const Text(AppStrings.areYouSure),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(AppStrings.no),
                                ),
                                TextButton(
                                  onPressed: () {
                                    postBloc.add(PostDeleteAllButtonClickedEvent());
                                    Future.delayed(const Duration(microseconds: 1000), () {
                                      postBloc.selectedPosts = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(AppStrings.yes),
                                ),
                              ],
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
                                backgroundColor: const Color.fromARGB(255, 113, 205, 217),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: AppStrings.edit,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  postBloc.add(PostDeleteButtonClickedEvent(postModel));
                                },
                                backgroundColor: const Color.fromARGB(255, 201, 32, 46),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: AppStrings.delete,
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
                                Expanded(
                                  child: Text(
                                    postModel.title.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: FontSize.s18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.clip,
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
                                postModel.imagePath != null
                                    ? ImageFrame(
                                        imagePath: postModel.imagePath,
                                        size: size,
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text(
                                  postModel.content,
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
                                    DateFormat.yMEd().add_jm().format(postModel.createdAt!),
                                    style: TextStyle(
                                      fontSize: FontSize.s12,
                                      color: ColorManager.blue,
                                    ),
                                  ),
                                ),
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
            return const Scaffold(body: Center(child: Text(AppStrings.error)));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
