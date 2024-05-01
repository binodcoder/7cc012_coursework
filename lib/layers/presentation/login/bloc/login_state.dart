import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

abstract class LoginActionState extends LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginActionState {}

class LoggedState extends LoginActionState {}

class LoggedOutState extends LoginActionState {}

class LoginErrorState extends LoginActionState {
  final String message;
  LoginErrorState({required this.message});
}
