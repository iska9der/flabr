import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/auth_data_model.dart';
import '../model/me_model.dart';
import '../repository/auth_repository.dart';
import '../repository/token_repository.dart';

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
    String? csrf = await _tokenRepository.getCsrf();

    if (authData == null) {
      return emit(state.copyWith(status: AuthStatus.unauthorized));
    }

    emit(state.copyWith(
      status: AuthStatus.authorized,
      data: authData,
      csrfToken: csrf,
    ));

    fetchMe();
  }

  void fetchCsrf() async {
    final csrf = await _repository.fetchCsrf(state.data);

    _tokenRepository.setCsrf(csrf);

    emit(state.copyWith(csrfToken: csrf));
  }

  void fetchMe() async {
    try {
      final me = await _repository.fetchMe(state.data.connectSID);

      emit(state.copyWith(me: me));
    } catch (e) {
      emit(state.copyWith(me: MeModel.empty));
    }
  }

  void handleAuthData() {
    emit(state.copyWith(status: AuthStatus.loading));

    final authData = _tokenRepository.authData;

    if (authData.isEmpty) return;

    emit(state.copyWith(status: AuthStatus.authorized, data: authData));
  }

  logOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenRepository.clearAll();

    emit(state.copyWith(status: AuthStatus.unauthorized));
  }
}
