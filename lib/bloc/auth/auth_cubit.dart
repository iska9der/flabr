import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository,
       super(const AuthState());

  final TokenRepository _tokenRepository;

  Future<void> init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenRepository.init();

    _tokenRepository.onTokenChanged.listen((token) async {
      if (token.isNotEmpty) {
        emit(state.copyWith(status: AuthStatus.authorized, token: token));
      } else {
        emit(const AuthState(status: AuthStatus.unauthorized));
      }
    });
  }

  Future<void> logOut() async {
    await _tokenRepository.clearAll();
  }
}
