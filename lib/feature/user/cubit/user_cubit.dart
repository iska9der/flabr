import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/localization/language_enum.dart';
import '../model/user_model.dart';
import '../model/user_whois_model.dart';
import '../repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
    String login, {
    required UserRepository repository,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _repository = repository,
        super(UserState(login: login, model: UserModel.empty));

  final UserRepository _repository;

  void fetchByLogin() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      UserModel model;

      if (state.model.isEmpty) {
        model = await _repository.fetchByLogin(
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
      UserModel model = _repository.getByLogin(state.login);

      emit(state.copyWith(status: UserStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }

  void fetchWhois() async {
    UserWhoisModel model;

    if (state.whoisModel.isEmpty) {
      model = await _repository.fetchWhois(
        login: state.login,
        langUI: state.langUI,
        langArticles: state.langArticles,
      );
    } else {
      model = state.whoisModel;
    }

    emit(state.copyWith(whoisModel: model));
  }
}
