import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/user/user_model.dart';
import '../../../../../data/model/user/user_whois_model.dart';
import '../../../../../data/repository/part.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
    String login, {
    required UserRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(UserState(login: login, model: UserModel.empty));

  final UserRepository _repository;
  final LanguageRepository _languageRepository;

  void fetchCard() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      UserModel model = state.model;

      if (model.isEmpty) {
        model = await _repository.fetchCard(
          login: state.login,
          langUI: _languageRepository.ui,
          langArticles: _languageRepository.articles,
        );
      }

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
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
      );
    } else {
      model = state.whoisModel;
    }

    emit(state.copyWith(whoisModel: model));
  }
}
