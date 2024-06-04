import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/auth_data_model.dart';
import '../../../../data/model/user_me_model.dart';
import '../../../../data/repository/part.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository repository,
    required TokenRepository tokenRepository,
  })  : _repository = repository,
        _tokenRepository = tokenRepository,
        super(const AuthState());

  final AuthRepository _repository;
  final TokenRepository _tokenRepository;

  void init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    AuthDataModel? authData = await _tokenRepository.getData();

    if (authData == null) {
      return emit(state.copyWith(status: AuthStatus.unauthorized));
    }

    emit(state.copyWith(
      status: AuthStatus.authorized,
      data: authData,
    ));
  }

  void fetchCsrf() async {
    final csrf = await _repository.fetchCsrf(state.data);

    _tokenRepository.setCsrf(csrf);
  }

  void fetchMe() async {
    try {
      final me = await _repository.fetchMe();

      if (me == null) {
        return emit(state.copyWith(status: AuthStatus.anomaly));
      }

      emit(state.copyWith(me: me));
    } catch (e) {
      emit(state.copyWith(me: UserMeModel.empty));
    }
  }

  void handleAuthData() {
    emit(state.copyWith(status: AuthStatus.loading));

    final authData = _tokenRepository.authData;

    if (authData.isEmpty) return;

    emit(state.copyWith(status: AuthStatus.authorized, data: authData));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenRepository.clearAll();

    emit(state.copyWith(status: AuthStatus.unauthorized));
  }
}
