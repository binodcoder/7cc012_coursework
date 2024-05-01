import 'package:dartz/dartz.dart';
import '../../../../core/entities/login.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/login/repositories/login_repositories.dart';
import '../datasources/login_local_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginLocalDataSource localDataSource;
  LoginRepositoryImpl({
    required this.localDataSource,
  });
/*
Either is class from dartz package which helps to do functional programming
when login is success Right side will return otherwise left.
 */
  @override
  Future<Either<Failure, User>>? login(LoginModel loginModel) async {
    try {
      User response = await localDataSource.login(loginModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on LoginException {
      return Left(LoginFailure());
    }
  }
}
