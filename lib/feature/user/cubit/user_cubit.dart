import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/user_model.dart';
import '../service/users_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(String login, {required UsersService service})
      : _service = service,
        super(UserState(login: login, model: UserModel.empty));

  final UsersService _service;

  void fetchByLogin() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      UserModel model = await _service.fetchByLogin(state.login);

      emit(state.copyWith(status: UserStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }

  void getByLogin() {
    try {
      UserModel model = _service.getByLogin(state.login);

      emit(state.copyWith(status: UserStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }
}
