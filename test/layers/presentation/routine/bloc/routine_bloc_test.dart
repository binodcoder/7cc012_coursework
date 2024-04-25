import 'package:blog_app/core/entities/post.dart';
import 'package:blog_app/core/errors/failures.dart';
import 'package:blog_app/core/model/post_model.dart';
import 'package:blog_app/layers/domain/post/usecases/delete_post.dart';
import 'package:blog_app/layers/domain/post/usecases/read_posts.dart';
import 'package:blog_app/layers/presentation/post/read_posts/bloc/read_posts_bloc.dart';
import 'package:blog_app/layers/presentation/post/read_posts/bloc/read_posts_event.dart';
import 'package:blog_app/layers/presentation/post/read_posts/bloc/read_posts_state.dart';
import 'package:blog_app/resources/strings_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'routine_bloc_test.mocks.dart';

@GenerateMocks([ReadPosts])
@GenerateMocks([DeletePost])
void main() {
  late ReadPostsBloc bloc;
  late MockGetPosts mockGetPosts;
  late MockDeletePost mockDeletePost;
  late MockFindPosts mockFindPosts;
  late MockUpdatePost mockUpdatePost;

  setUp(() {
    mockGetPosts = MockGetPosts();
    mockDeletePost = MockDeletePost(1);
    mockFindPosts = MockFindPosts();
    mockUpdatePost = MockUpdatePost();

    bloc = ReadPostsBloc(getPosts: mockGetPosts, deletePost: mockDeletePost, findPosts: mockFindPosts, updatePost: mockUpdatePost);
  });

  test('initialState should be PostInitialState', () async {
    //assert
    expect(bloc.initialState, equals(PostInitialState()));
  });

  group('GetRoutines', () {
    final tPostModel = [
      PostModel(
        id: 37,
        content: '',
        isSelected: 0,
        title: '',
      )
    ];

    test('should get data from the routine usecase', () async* {
      //arrange

      when(mockGetPosts(any)).thenAnswer((_) async => Right(tPostModel));
      //act
      bloc.add(PostInitialEvent());
      await untilCalled(mockGetPosts(any));

      //assert
      verify(mockGetPosts(any));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully', () async* {
      //arrange

      when(mockGetPosts(any)).thenAnswer((_) async => Right(tPostModel));

      //assert later
      final expected = [PostInitialState(), PostLoadingState(), PostLoadedSuccessState(tPostModel, false, [])];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostInitialEvent());
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange

      when(mockGetPosts(any)).thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [PostInitialState(), PostLoadingState(), PostErrorState(AppStrings.serverFailureMessage)];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostInitialEvent());
    });

    test('should emits [Loading, Error] with a proper message for the error when getting data fails', () async* {
      //arrange

      when(mockGetPosts(any)).thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [PostInitialState(), PostLoadingState(), PostErrorState(AppStrings.cacheFailureMessage)];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostInitialEvent());
    });
  });

  group('DeletePost', () {
    final tPost = Post(
      id: 37,
      content: '',
      isSelected: 0,
      title: '',
    );

    test('should get int from the delete usecase', () async* {
      //arrange
      when(mockDeletePost(tPost)).thenAnswer((_) async => const Right(1));
      //act
      bloc.add(PostDeleteButtonClickedEvent(tPost));
      await untilCalled(mockDeletePost(tPost));

      //assert
      verify(mockDeletePost(tPost));
    });
    test('should emits [Loading, Loaded] when data is gotten successfully', () async* {
      //arrange
      when(mockDeletePost(tPost)).thenAnswer((_) async => const Right(1));

      //assert later
      final expected = [
        PostInitialState(),
        PostLoadingState(),
        PostLoadedSuccessState([tPost], false, [])
      ];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostDeleteButtonClickedEvent(tPost));
    });
    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockDeletePost(tPost)).thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [PostInitialState(), PostLoadingState(), PostErrorState(AppStrings.serverFailureMessage)];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostDeleteButtonClickedEvent(tPost));
    });

    test('should emits [Loading, Error] with a proper message for the error when getting data fails', () async* {
      //arrange
      when(mockDeletePost(tPost)).thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [PostInitialState(), PostLoadingState(), PostErrorState(AppStrings.cacheFailureMessage)];
      expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(PostDeleteButtonClickedEvent(tPost));
    });
  });
}
