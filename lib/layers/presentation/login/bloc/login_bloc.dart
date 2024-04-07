import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../../../../injection_container.dart';
import '../../../../resources/strings_manager.dart';
import '../../../domain/login/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;

  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  LoginBloc({required this.login}) : super(LoginInitialState()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressEvent>(loginButtonPressEvent);
    on<LogoutButtonPressEvent>(logoutButtonPressEvent);
  }

  FutureOr<void> loginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }

  FutureOr<void> loginButtonPressEvent(LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final result = await login(event.loginModel);
    result!.fold((failure) {
      emit(LoginErrorState(message: _mapFailureToMessage(failure)));
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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return AppStrings.CACHE_FAILURE_MESSAGE;
      case LoginFailure:
        return AppStrings.LOGIN_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
