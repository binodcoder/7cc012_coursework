import 'dart:convert';
import 'package:blog_app/core/db/db_helper.dart';
import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/model/post_model.dart';
import 'package:blog_app/layers/data/post/data_sources/posts_local_data_sources.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([
  DatabaseHelper
], customMocks: [
  MockSpec<DatabaseHelper>(as: #MockDatabaseHelperForTest, returnNullOnMissingStub: true),
])
void main() {
  late PostLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = PostLocalDataSourceImpl();
  });

  group('getLastPost', () {
    final tPostModel = PostModel.fromJson(json.decode(fixture('post_cached.json')));
    test('should return Post from local db when there is one in the cache', () async {
      //arrange
      when(await DatabaseHelper.getPosts()).thenReturn([tPostModel]);
      //act
      final result = await dataSource.readPosts();
      //assert
      verify(DatabaseHelper.getPosts());
      expect(result, equals(tPostModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      //arrange
      when(await DatabaseHelper.getPosts()).thenReturn([tPostModel]);
      //act
      final call = dataSource.readPosts;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cachePostModel', () {
    final tPostModel = PostModel(
      id: 37,
      content: '',
      isSelected: 0,
      title: '',
    );
    test('should call db to cache the data', () async {
      //act
      dataSource.createPost(tPostModel);
      //assert
      verify(DatabaseHelper.insertPost(tPostModel));
    });
  });
}
