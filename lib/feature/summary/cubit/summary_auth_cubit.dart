import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/repository_part.dart';

part 'summary_auth_state.dart';

class SummaryAuthCubit extends Cubit<SummaryAuthState> {
  SummaryAuthCubit({
    required SummaryTokenRepository tokenRepository,
  })  : _tokenRepository = tokenRepository,
        super(const SummaryAuthState());

  final SummaryTokenRepository _tokenRepository;

  void init() async {
    emit(state.copyWith(status: SummaryAuthStatus.loading));

    final token = await _tokenRepository.getToken();

    if (token == null) {
      return emit(state.copyWith(status: SummaryAuthStatus.unauthorized));
    }

    emit(state.copyWith(
      status: SummaryAuthStatus.authorized,
      token: token,
    ));
  }

  void saveToken(String token) async {
    if (token.isEmpty) return;

    emit(state.copyWith(status: SummaryAuthStatus.loading));

    await _tokenRepository.setToken(token);

    emit(state.copyWith(status: SummaryAuthStatus.authorized, token: token));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: SummaryAuthStatus.loading));

    await _tokenRepository.clear();

    emit(state.copyWith(status: SummaryAuthStatus.unauthorized, token: ''));
  }
}
