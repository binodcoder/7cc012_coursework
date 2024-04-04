import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/login.dart';
import '../../../../core/model/user_model.dart';

abstract class LoginLocalDataSource {
  Future<UserModel> login(LoginModel loginModel);
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  Future<UserModel> _login(LoginModel loginModel) async {
    List<UserModel> userModel = await DatabaseHelper.login(loginModel);
    return userModel.first;
  }

  @override
  Future<UserModel> login(LoginModel loginModel) => _login(loginModel);
}
