import 'package:blog_app/core/entities/post.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/layers/domain/post/repositories/post_repositories.dart';
import 'package:blog_app/layers/domain/post/usecases/read_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late ReadPosts usecase;
  late MockPostRepository mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = ReadPosts(mockPostRepository);
  });
  const tId = 1;
  List<Post> tPost = [
    Post(
      id: tId,
      title: '',
      content: '',
      imagePath: '',
      isSelected: 0,
      createdAt: DateTime.now(),
    )
  ];
  test(
    'should get blog post for the number from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When readPost is called with any argument, always answer with
      // the Right "side" of Either containing a test Post object.
      when(mockPostRepository.readPosts()).thenAnswer((_) async => Right(tPost));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(NoParams());
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(tPost));
      // Verify that the method has been called on the Repository
      verify(mockPostRepository.readPosts());
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
