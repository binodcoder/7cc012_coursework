import 'package:blog_app/core/entities/post.dart';
import 'package:blog_app/layers/domain/post/repositories/post_repositories.dart';
import 'package:blog_app/layers/domain/post/usecases/find_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late FindPosts usecase;
  late MockPostRepository mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = FindPosts(mockPostRepository);
  });

  List<Post> tPost = [
    Post(
      id: 1,
      title: '',
      content: '',
      imagePath: '',
      isSelected: 0,
      createdAt: DateTime.now(),
    )
  ];
  String searchTerm = "nepal";
  test(
    'should get all blog post from the repository related to search term',
    () async {
      when(mockPostRepository.findPosts(searchTerm)).thenAnswer((_) async => Right(tPost));
      final result = await usecase(searchTerm);
      expect(result, Right(tPost));
      verify(mockPostRepository.findPosts(searchTerm));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
