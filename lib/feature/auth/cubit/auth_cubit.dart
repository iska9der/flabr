import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/storage/cache_storage.dart';
import '../model/auth_data_model.dart';
import '../service/auth_service.dart';

part 'auth_state.dart';

const authDataCacheKey = 'aData';
const authCsrfCacheKey = 'cData';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required CacheStorage storage,
    required AuthService service,
  })  : _storage = storage,
        _service = service,
        super(const AuthState());

  final CacheStorage _storage;
  final AuthService _service;

  void init() async {
    emit(state.copyWith(status: AuthStatus.loading));

    String? rawData = await _storage.read(authDataCacheKey);
    String? rawCsrf = await _storage.read(authCsrfCacheKey);

    if (rawData == null) {
      return emit(state.copyWith(status: AuthStatus.unauthorized));
    }

    AuthDataModel data = AuthDataModel.fromJson(rawData);

    emit(state.copyWith(
      status: AuthStatus.authorized,
      data: data,
      csrfToken: rawCsrf,
    ));
  }

  void handleAuthData() {
    final authData = _service.authData;

    if (authData.isEmpty) return;

    _storage.write(authDataCacheKey, authData.toJson());

    emit(state.copyWith(status: AuthStatus.authorized, data: authData));

    _service.clearCachedAuth();
  }

  logOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _storage.delete(authDataCacheKey);
    await _storage.delete(authCsrfCacheKey);

    emit(state.copyWith(status: AuthStatus.unauthorized));
  }
}
