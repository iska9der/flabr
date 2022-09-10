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

    if (!emailValidation.hasMatch(value)) {
      return emit(state.copyWith(
        status: LoginStatus.failure,
        error: 'Некорректная почта',
      ));
    } else {
      emit(state.copyWith(status: LoginStatus.initial));
    }

    emit(state.copyWith(login: value));
  }

  void onPasswordChanged(String value) {
    if (value == state.password) return;

    emit(state.copyWith(password: value));
  }

  submit() async {
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
