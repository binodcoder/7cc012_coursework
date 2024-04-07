import 'package:blog_app/core/entities/post.dart';
import 'package:blog_app/layers/domain/post/repositories/post_repositories.dart';
import 'package:blog_app/layers/domain/post/usecases/update_post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late UpdatePost usecase;
  late MockPostRepository mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = UpdatePost(mockPostRepository);
  });

  int tResponse = 1;

  Post tPost = Post(
    id: 1,
    title: '',
    content: '',
    imagePath: '',
    isSelected: 0,
    createdAt: DateTime.now(),
  );

  test(
    'should get int from the repository',
    () async {
      when(mockPostRepository.updatePost(tPost)).thenAnswer((_) async => Right(tResponse));
      final result = await usecase(tPost);
      expect(result, Right(tResponse));
      verify(mockPostRepository.updatePost(tPost));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
