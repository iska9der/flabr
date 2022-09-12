import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/auth_data_model.dart';
import '../model/me_model.dart';
import '../service/auth_service.dart';
import '../service/token_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthService service, required TokenService tokenService})
      : _service = service,
        _tokenService = tokenService,
        super(const AuthState());

  final AuthService _service;
  final TokenService _tokenService;

  void init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    AuthDataModel? authData = await _tokenService.getData();
    String? csrf = await _tokenService.getCsrf();

    if (authData == null) {
      return emit(state.copyWith(status: AuthStatus.unauthorized));
    }

    emit(state.copyWith(
      status: AuthStatus.authorized,
      data: authData,
      csrfToken: csrf,
    ));

    _fetchMe();
  }

  void _fetchMe() async {
    final me = await _service.fetchMe(state.data.connectSID);

    emit(state.copyWith(me: me));
  }

  void handleAuthData() {
    final authData = _tokenService.authData;

    if (authData.isEmpty) return;

    emit(state.copyWith(status: AuthStatus.authorized, data: authData));
  }

  logOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _tokenService.clearAll();

    emit(state.copyWith(status: AuthStatus.unauthorized));
  }
}
