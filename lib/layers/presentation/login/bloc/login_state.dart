abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitialState extends LoginState {}

class ReadyToLoginState extends LoginState {}

class LoginLoadingState extends LoginActionState {}

class LoggedState extends LoginActionState {}

class LoggedOutState extends LoginActionState {}

class LoginErrorState extends LoginActionState {
  final String message;

  LoginErrorState({required this.message});
}
