import 'package:blog_app/core/errors/exceptions.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/login.dart';
import '../../../../core/model/user_model.dart';

/*abstract class holds one abstract method which is later implemented
by calling static login method from DatabaseHelper class.
*/
abstract class LoginLocalDataSource {
  Future<UserModel> login(LoginModel loginModel);
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  //this gives first model when success otherwise login exception.
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
