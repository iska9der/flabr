import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/repository.dart';
import '../../../presentation/extension/extension.dart';

part 'login_state.dart';

final emailValidation = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required TokenRepository tokenRepository})
    : _tokenRepository = tokenRepository,
      super(const LoginState());

  final TokenRepository _tokenRepository;

  Future<void> handle({required String token, bool isManual = false}) async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: LoginStatus.loading));

    await Future.delayed(const Duration(seconds: 1));
    await _tokenRepository.saveToken(token, asCookie: isManual);

    emit(state.copyWith(status: LoginStatus.success));
  }
}
