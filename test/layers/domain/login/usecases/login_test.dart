import 'package:blog_app/core/entities/login.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/layers/domain/login/repositories/login_repositories.dart';
import 'package:blog_app/layers/domain/login/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late Login usecase;
  late MockLoginRepository mockLoginRepository;
  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = Login(mockLoginRepository);
  });

  User tUser = User(email: "", name: " ", password: " ");
  LoginModel tLoginModel = LoginModel(email: "", password: "");
  test(
    'should get user from the repository',
    () async {
      when(mockLoginRepository.login(tLoginModel)).thenAnswer((_) async => Right(tUser));
      final result = await usecase(tLoginModel);
      expect(result, Right(tUser));
      verify(mockLoginRepository.login(tLoginModel));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
