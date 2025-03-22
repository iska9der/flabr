import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/tokens_model.dart';
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

  void init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    Tokens? tokens = await _tokenRepository.getTokens();

    if (tokens == null) {
      return emit(state.copyWith(status: AuthStatus.unauthorized));
    }

    emit(state.copyWith(status: AuthStatus.authorized, tokens: tokens));
  }

  void fetchMe() async {
    try {
      final me = await _repository.fetchMe();

      if (me == null) {
        return emit(state.copyWith(status: AuthStatus.anomaly));
      }

      emit(state.copyWith(me: me));
    } catch (e, stack) {
      emit(state.copyWith(me: UserMe.empty));
      Error.throwWithStackTrace(e, stack);
    }
  }

  void fetchUpdates() async {
    try {
      final updates = await _repository.fetchUpdates();

      emit(state.copyWith(updates: updates));
    } catch (e, stack) {
      Error.throwWithStackTrace(e, stack);
    }
  }

  void handleTokens() {
    emit(state.copyWith(status: AuthStatus.loading));

    final tokens = _tokenRepository.tokens;

    if (tokens.isEmpty) return;

    emit(state.copyWith(status: AuthStatus.authorized, tokens: tokens));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenRepository.clearAll();

    emit(state.copyWith(status: AuthStatus.unauthorized));
  }
}
