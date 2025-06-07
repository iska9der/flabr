import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/user/user.dart';
import '../../../data/repository/repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository repository,
    required TokenRepository tokenRepository,
  }) : _repository = repository,
       _tokenRepository = tokenRepository,
       super(const AuthState());

  final AuthRepository _repository;
  final TokenRepository _tokenRepository;

  Future<void> init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenRepository.init();

    _tokenRepository.onTokenChanged.listen((token) {
      if (token.isNotEmpty) {
        emit(state.copyWith(status: AuthStatus.authorized, token: token));
        fetchMe();
        fetchUpdates();
      } else {
        emit(const AuthState(status: AuthStatus.unauthorized));
      }
    });
  }

  Future<void> fetchMe() async {
    try {
      final me = await _repository.fetchMe();

      if (me == null) {
        return emit(state.copyWith(status: AuthStatus.anomaly));
      }

      emit(state.copyWith(me: me));
    } catch (error, stackTrace) {
      emit(state.copyWith(me: UserMe.empty));

      super.onError(error, stackTrace);
    }
  }

  Future<void> fetchUpdates() async {
    try {
      final updates = await _repository.fetchUpdates();

      emit(state.copyWith(updates: updates));
    } catch (error, stackTrace) {
      super.onError(error, stackTrace);
    }
  }

  Future<void> logOut() async {
    await _tokenRepository.clearAll();
  }
}
