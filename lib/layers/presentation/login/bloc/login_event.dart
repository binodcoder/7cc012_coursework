import 'package:blog_app/core/entities/login.dart';

import '../../../../core/entities/user.dart';

abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {
  final LoginModel loginModel;
  LoginButtonPressEvent(this.loginModel);
}

class LogoutButtonPressEvent extends LoginEvent {}
