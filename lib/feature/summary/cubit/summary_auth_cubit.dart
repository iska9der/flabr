import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/summary_token_repository.dart';

part 'summary_auth_state.dart';

class SummaryAuthCubit extends Cubit<SummaryAuthState> {
  SummaryAuthCubit({required this._tokenRepository})
    : super(const SummaryAuthState());

  final SummaryTokenRepository _tokenRepository;

  Future<void> init() async {
    emit(state.copyWith(status: .loading));

    final token = await _tokenRepository.getToken();
    if (token == null) {
      return emit(state.copyWith(status: .unauthorized));
    }

    emit(state.copyWith(status: .authorized, token: token));
  }

  Future<void> saveToken(String token) async {
    if (token.isEmpty) return;

    emit(state.copyWith(status: .loading));
    await _tokenRepository.setToken(token);
    emit(state.copyWith(status: .authorized, token: token));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: .loading));
    await _tokenRepository.clear();
    emit(state.copyWith(status: .unauthorized, token: ''));
  }
}
