import 'package:blog_app/core/model/post_model.dart';
import 'package:blog_app/layers/data/post/data_sources/posts_local_data_sources.dart';
import 'package:blog_app/layers/data/post/repositories/post_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

@GenerateMocks([
  PostLocalDataSource
], customMocks: [
  MockSpec<PostLocalDataSource>(as: #MockPostRemoteDataSourceForTest, returnNullOnMissingStub: true),
])
void main() {
  late PostRepositoryImpl repository;

  late MockPostLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockPostLocalDataSource();
    repository = PostRepositoryImpl(
      postLocalDataSource: mockLocalDataSource,
    );
  });

  group('getPost', () {
    final tPostModel = [
      PostModel(
        content: '',
        isSelected: 0,
        title: '',
      )
    ];
    test('should return remote data when the call to remote data source is successful', () async {
      //arrange
      when(mockLocalDataSource.readPosts()).thenAnswer((_) async => tPostModel);
      //act
      final result = await repository.readPosts();
      //assert
      verify(mockLocalDataSource.readPosts());
      expect(result, equals(Right(tPostModel)));
    });
  });
}
