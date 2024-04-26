// Mocks generated by Mockito 5.4.2 from annotations
// in flutter_app/test/layers/presentation/Post/bloc/Post_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as i5;

import 'package:blog_app/core/errors/failures.dart' as i6;
import 'package:blog_app/core/usecases/usecase.dart' as i9;
import 'package:blog_app/core/model/post_model.dart' as i7;
import 'package:blog_app/core/entities/post.dart' as i12;
import 'package:blog_app/layers/domain/post/repositories/post_repositories.dart' as i2;
import 'package:blog_app/layers/domain/post/usecases/delete_post.dart' as i4;
import 'package:blog_app/layers/domain/post/usecases/read_posts.dart' as i8;
import 'package:blog_app/layers/domain/post/usecases/find_posts.dart' as i10;
import 'package:blog_app/layers/domain/post/usecases/update_post.dart' as i11;
import 'package:dartz/dartz.dart' as i3;
import 'package:mockito/mockito.dart' as i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePostRepository_0 extends i1.Fake implements i2.PostRepository {}

/// A class which mocks [DeletePost].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeletePost extends i1.Mock implements i4.DeletePost {
  MockDeletePost(any) {
    i1.throwOnMissingStub(this);
  }
  int id = 1;

  @override
  i5.Future<i3.Either<i6.Failure, int>?> call(id) =>
      (super.noSuchMethod(Invocation.method(#call, [int]), returnValue: Future<i3.Either<i6.Failure, int>?>.value())
          as i5.Future<i3.Either<i6.Failure, int>?>);
}

/// A class which mocks [GetPosts].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetPosts extends i1.Mock implements i8.ReadPosts {
  MockGetPosts() {
    i1.throwOnMissingStub(this);
  }

  @override
  i2.PostRepository get repository => (super.noSuchMethod(Invocation.getter(#repository), returnValue: _FakePostRepository_0()) as i2.PostRepository);
  @override
  i5.Future<i3.Either<i6.Failure, List<i7.PostModel>>?> call(i9.NoParams? noParams) =>
      (super.noSuchMethod(Invocation.method(#call, [noParams]), returnValue: Future<i3.Either<i6.Failure, List<i7.PostModel>>?>.value())
          as i5.Future<i3.Either<i6.Failure, List<i7.PostModel>>?>);
}

/// A class which mocks [FindPosts].
///
/// See the documentation for Mockito's code generation for more information.
class MockFindPosts extends i1.Mock implements i10.FindPosts {
  MockFindPosts() {
    i1.throwOnMissingStub(this);
  }
  String searchTerm = "..";

  i2.PostRepository get repository => (super.noSuchMethod(Invocation.getter(#repository), returnValue: _FakePostRepository_0()) as i2.PostRepository);

  @override
  i5.Future<i3.Either<i6.Failure, List<i12.Post>>?> call(searchTerm) =>
      (super.noSuchMethod(Invocation.method(#call, [searchTerm]), returnValue: Future<i3.Either<i6.Failure, List<i12.Post>>?>.value())
          as i5.Future<i3.Either<i6.Failure, List<i12.Post>>?>);
}

/// A class which mocks [UpdatePost].
///
/// See the documentation for Mockito's code generation for more information.
class MockUpdatePost extends i1.Mock implements i11.UpdatePost {
  MockUpdatePost() {
    i1.throwOnMissingStub(this);
  }

  i12.Post tPost = i12.Post(
    content: '',
    isSelected: 0,
    title: '',
  );

  i2.PostRepository get repository => (super.noSuchMethod(Invocation.getter(#repository), returnValue: _FakePostRepository_0()) as i2.PostRepository);
  @override
  i5.Future<i3.Either<i6.Failure, int>?> call(tPost) =>
      (super.noSuchMethod(Invocation.method(#call, [tPost]), returnValue: Future<i3.Either<i6.Failure, int>?>.value())
          as i5.Future<i3.Either<i6.Failure, int>?>);
}