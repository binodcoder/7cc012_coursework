import 'package:blog_app/core/model/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import '../../fixtures/fixture_reader.dart';

void main() {
  final tPostModel = PostModel(
    id: 1,
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
      final Map<String, dynamic> jsonMap = json.decode(fixture('post.json'));
      //act
      final result = PostModel.fromJson(jsonMap);
      //assert
      expect(result.id, equals(tPostModel.id));
    });
    test('should return a valid model when the JSON title is regarded as a long', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('post_title_long.json'));
      //act
      final result = PostModel.fromJson(jsonMap);
      //assert
      expect(result.id, equals(tPostModel.id));
    });
  });

  group('toJson', () {
    test('should return ', () async {
      //act
      final result = tPostModel.toMap();
      //assert
      final expectedMap = {
        "content": '',
        "isSelected": 0,
        "imagePath": null,
        "title": '',
      };
      expect(result, equals(expectedMap));
    });
  });
}
