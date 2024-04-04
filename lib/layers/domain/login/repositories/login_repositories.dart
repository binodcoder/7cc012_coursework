import 'package:dartz/dartz.dart';
import '../../../../core/entities/login.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>>? login(LoginModel loginModel);
}
