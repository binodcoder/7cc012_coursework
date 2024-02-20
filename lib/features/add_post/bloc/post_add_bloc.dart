import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../db/db_helper.dart';
import 'post_add_event.dart';
import 'post_add_state.dart';

class PostAddBloc extends Bloc<PostAddEvent, PostAddState> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  PostAddBloc() : super(PostAddInitialState()) {
    on<PostAddInitialEvent>(postAddInitialEvent);

    on<PostAddPickFromGalaryButtonPressEvent>(addPostPickFromGalaryButtonPressEvent);
    on<PostAddPickFromCameraButtonPressEvent>(addPostPickFromCameraButtonPressEvent);
    on<PostAddSaveButtonPressEvent>(addPostSaveButtonPressEvent);
  }

  FutureOr<void> addPostPickFromGalaryButtonPressEvent(PostAddPickFromGalaryButtonPressEvent event, Emitter<PostAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromGalaryState(imagePath));
    }
  }

  Future<Uint8List?> getBytesFromImage(File? image) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    return bytes;
  }

  Future<String> saveImage(Uint8List? imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData!);
    return imagePath;
  }

  FutureOr<void> addPostPickFromCameraButtonPressEvent(PostAddPickFromCameraButtonPressEvent event, Emitter<PostAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> addPostSaveButtonPressEvent(PostAddSaveButtonPressEvent event, Emitter<PostAddState> emit) {}

  FutureOr<void> postAddInitialEvent(PostAddInitialEvent event, Emitter<PostAddState> emit) {
    emit(PostAddInitialState());
  }
}

// class PostBloc extends Bloc<PostEvent, PostLoadedSuccessState> {
//   PostBloc() : super(PostLoadedSuccessState([]));

//   List<Post> selectedPosts = [];

//   @override
//   Stream<PostLoadedSuccessState> mapEventToState(PostEvent event) async* {
//     if (event is AddPostEvent) {
//       List<Post> updatedPosts = List.from(state.posts)..add(event.post);
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is UpdatePostEvent) {
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.updatedPost.id) {
//           return event.updatedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeletePostEvent) {
//       List<Post> updatedPosts = state.posts.where((post) => post.id != event.postId).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is SelectPostEvent) {
//       selectedPosts.add(event.selectedPost);
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.selectedPost.id) {
//           return event.selectedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeSelectPostEvent) {
//       selectedPosts.remove(event.selectedPost);
//       List<Post> updatedPosts = state.posts.map((post) {
//         if (post.id == event.selectedPost.id) {
//           return event.selectedPost;
//         }
//         return post;
//       }).toList();
//       yield state.copyWith(posts: updatedPosts);
//     } else if (event is DeletePostEvents) {
//       for (var element in selectedPosts) {
//         state.posts.remove(element);
//       }
//       yield state.copyWith(posts: state.posts);
//     }
//   }
// }
