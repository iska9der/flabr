import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/tokens_model.dart';
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

  Future<void> submitConnectSid(String value) async {
    if (state.status.isLoading) return;

    if (value.isEmpty) {
      return emit(
        state.copyWith(
          status: LoginStatus.failure,
          error: 'Пустой значение токена',
        ),
      );
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final tokens = Tokens(connectSID: value);
    await _tokenRepository.setTokens(tokens);

    emit(state.copyWith(status: LoginStatus.success));
  }
}
