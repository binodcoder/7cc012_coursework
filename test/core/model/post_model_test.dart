import 'package:blog_app/core/model/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import '../../fixtures/fixture_reader.dart';

void main() {
  final tPostModel = PostModel(
    id: 37,
    content: '',
    isSelected: 0,
    title: '',
  );

  test('should be a subclass of Post model', () async {
    //assert
    expect(tPostModel, isA<PostModel>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('Post.json'));
      //act
      final result = PostModel.fromJson(jsonMap);
      //assert
      expect(result.id, equals(tPostModel.id));
    });
    test('should return a valid model when the JSON duration is regarded as a double', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('Post_duration_double.json'));
      //act
      final result = PostModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tPostModel));
    });
  });

  group('toJson', () {
    test('should return ', () async {
      //act
      final result = tPostModel.toMap();
      //assert
      final expectedMap = {
        "id": 37,
        "content": '',
        "isSelected": 0,
        "title": '',
      };
      expect(result, equals(expectedMap));
    });
  });
}
