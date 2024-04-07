import 'package:blog_app/core/errors/exceptions.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/login.dart';
import '../../../../core/model/user_model.dart';

abstract class LoginLocalDataSource {
  Future<UserModel> login(LoginModel loginModel);
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  Future<UserModel> _login(LoginModel loginModel) async {
    List<UserModel> userModels = await DatabaseHelper.login(loginModel);
    if (userModels.isNotEmpty) {
      return userModels.first;
    } else {
      throw LoginException();
    }
  }

  @override
  Future<UserModel> login(LoginModel loginModel) => _login(loginModel);
}
