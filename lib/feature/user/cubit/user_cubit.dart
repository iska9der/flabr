import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/localization/language_enum.dart';
import '../model/user_model.dart';
import '../model/user_whois_model.dart';
import '../service/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
    String login, {
    required UserService service,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(UserState(login: login, model: UserModel.empty));

  final UserService _service;

  void fetchByLogin() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      UserModel model;

      if (state.model.isEmpty) {
        model = await _service.fetchByLogin(
          login: state.login,
          langUI: state.langUI,
          langArticles: state.langArticles,
        );
      } else {
        model = state.model;
      }

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

  void fetchWhois() async {
    try {
      UserWhoisModel model;

      if (state.whoisModel.isEmpty) {
        model = await _service.fetchWhois(
          login: state.login,
          langUI: state.langUI,
          langArticles: state.langArticles,
        );
      } else {
        model = state.whoisModel;
      }

      emit(state.copyWith(whoisModel: model));
    } catch (e) {}
  }
}
