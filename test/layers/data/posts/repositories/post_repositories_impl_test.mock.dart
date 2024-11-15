// Mocks generated by Mockito 5.4.2 from annotations
// in blog_app/layers/data/post/repositories/post_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as i4;
import 'package:blog_app/layers/data/post/data_sources/posts_local_data_sources.dart' as i5;
import 'package:blog_app/core/model/post_model.dart' as i2;
import 'package:blog_app/core/entities/post.dart' as i3;
import 'package:mockito/mockito.dart' as i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePostModel_0 extends i1.Fake implements i2.PostModel {}

/// A class which mocks [postsRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostsLocalDataSource extends i1.Mock implements i5.PostLocalDataSource {
  MockPostsLocalDataSource() {
    i1.throwOnMissingStub(this);
  }
  final tPost = i3.Post(
    id: 37,
    content: '',
    isSelected: 0,
    title: '',
  );

  @override
  i4.Future<List<i2.PostModel>> readPosts() => (super.noSuchMethod(Invocation.method(#ggetposts, []),
      returnValue: Future<List<i2.PostModel>>.value([_FakePostModel_0()]),
      returnValueForMissingStub: Future<List<i2.PostModel>>.value([_FakePostModel_0()])) as i4.Future<List<i2.PostModel>>);
  @override
  i4.Future<int> deletePost(tPost) =>
      (super.noSuchMethod(Invocation.method(#deletepost, [tPost]), returnValue: Future<int>.value(1), returnValueForMissingStub: Future<int>.value(1))
          as i4.Future<int>);
}
