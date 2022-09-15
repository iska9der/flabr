import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../service/auth_service.dart';
import '../service/token_service.dart';

part 'login_state.dart';

final emailValidation = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthService service,
    required TokenService tokenService,
  })  : _service = service,
        _tokenService = tokenService,
        super(const LoginState());

  final AuthService _service;
  final TokenService _tokenService;

  void onLoginChanged(String value) {
    if (value == state.login) return;

    emit(state.copyWith(login: value));

    validateLogin();
  }

  void onPasswordChanged(String value) {
    if (value == state.password) return;

    emit(state.copyWith(password: value));

    validatePassword();
  }

  validateAll() {
    List<bool> results = [validateLogin(), validatePassword()];

    if (results.any((result) => result == false)) {
      emit(state.copyWith(formStatus: LoginFormStatus.invalid));
      return;
    }

    emit(state.copyWith(formStatus: LoginFormStatus.valid));
  }

  bool validateLogin() {
    if (!emailValidation.hasMatch(state.login)) {
      emit(state.copyWith(
        loginStatus: LoginFieldStatus.invalid,
        loginError: 'Некорректная почта',
      ));

      return false;
    }

    emit(state.copyWith(
      loginStatus: LoginFieldStatus.valid,
      loginError: '',
    ));
    return true;
  }

  bool validatePassword() {
    if (state.password.length < 5) {
      emit(state.copyWith(
        passwordStatus: LoginFieldStatus.invalid,
        passwordError: 'Не скупись на символы',
      ));

      return false;
    }

    emit(state.copyWith(
      passwordStatus: LoginFieldStatus.valid,
      passwordError: '',
    ));
    return true;
  }

  submit() async {
    validateAll();

    if (state.formStatus == LoginFormStatus.invalid) return;

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final authData = await _service.login(
        login: state.login,
        password: state.password,
      );

      await _tokenService.setData(authData);

      emit(state.copyWith(status: LoginStatus.success));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
