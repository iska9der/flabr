import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../model/auth_data_model.dart';
import '../repository/token_repository.dart';

part 'login_state.dart';

final emailValidation = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required TokenRepository tokenRepository,
  })  : _tokenRepository = tokenRepository,
        super(const LoginState());

  final TokenRepository _tokenRepository;

  submitConnectSid(String value) async {
    if (state.status.isLoading) return;

    if (value.isEmpty) {
      return emit(state.copyWith(
        status: LoginStatus.failure,
        error: 'Пустой значение токена',
      ));
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final authData = AuthDataModel(connectSID: value);

    await _tokenRepository.setData(authData);

    emit(state.copyWith(status: LoginStatus.success));
  }
}
