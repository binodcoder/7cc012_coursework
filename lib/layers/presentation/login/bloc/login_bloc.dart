import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/user.dart';
import '../../../../injection_container.dart';
import '../../../domain/login/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;

  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  final DatabaseHelper dbHelper = DatabaseHelper();

  LoginBloc({required this.login}) : super(LoginInitialState()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressEvent>(loginButtonPressEvent);
    on<LogoutButtonPressEvent>(logoutButtonPressEvent);
  }

  FutureOr<void> loginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }

  FutureOr<void> loginButtonPressEvent(LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    final result = await login(event.loginModel);

    result!.fold((failure) {
      emit(LoginErrorState());
    }, (result) {
      emit(LoggedState());
      saveUserData(result);
    });
  }

  saveUserData(User user) {
    sharedPreferences.setBool('login', true);
    sharedPreferences.setInt('user_id', user.id ?? 1);
    sharedPreferences.setString('user_email', user.email);
    sharedPreferences.setString('role', user.role!);
  }

  FutureOr<void> logoutButtonPressEvent(LogoutButtonPressEvent event, Emitter<LoginState> emit) {
    sharedPreferences.clear();
    emit(LoggedOutState());
  }
}
