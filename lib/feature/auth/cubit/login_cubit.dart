import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/state_status_x.dart';
import '../model/auth_data_model.dart';
import '../repository/auth_repository.dart';
import '../repository/token_repository.dart';

part 'login_state.dart';

final emailValidation = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository repository,
    required TokenRepository tokenRepository,
  })  : _repository = repository,
        _tokenRepository = tokenRepository,
        super(const LoginState());

  final AuthRepository _repository;
  final TokenRepository _tokenRepository;

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
      final authData = await _repository.login(
        login: state.login,
        password: state.password,
      );

      await _tokenRepository.setData(authData);

      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: ExceptionHelper.parseMessage(e, 'Не удалось войти'),
      ));
    }
  }

  submitConnectSid(String value) async {
    if (state.status.isLoading || value.isEmpty) return;

    emit(state.copyWith(status: LoginStatus.loading));

    final authData = AuthDataModel(connectSID: value);

    await _tokenRepository.setData(authData);

    emit(state.copyWith(status: LoginStatus.success));
  }
}
