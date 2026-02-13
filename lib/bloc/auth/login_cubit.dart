import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/repository/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required TokenRepository tokenRepository})
    : _tokenRepository = tokenRepository,
      super(const LoginState());

  final TokenRepository _tokenRepository;

  Future<void> submit({required String token, bool isManual = false}) async {
    if (state.status == LoadingStatus.loading) return;

    emit(state.copyWith(status: LoadingStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    await _tokenRepository.saveToken(token, asCookie: isManual);

    emit(state.copyWith(status: LoadingStatus.success));
  }
}
