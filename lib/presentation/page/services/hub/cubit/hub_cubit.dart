import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/exception/part.dart';
import '../../../../../data/model/hub/hub_model.dart';
import '../../../../../data/model/hub/hub_profile_model.dart';
import '../../../../../data/repository/part.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit(
    String alias, {
    required HubRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(HubState(alias: alias));

  final HubRepository _repository;
  final LanguageRepository _languageRepository;

  void fetchProfile() async {
    HubProfile profile = state.profile;

    try {
      if (profile.isEmpty) {
        emit(state.copyWith(status: HubStatus.loading));

        profile = await _repository.fetchProfile(
          state.alias,
          langUI: _languageRepository.ui,
          langArticles: _languageRepository.articles,
        );
      }

      emit(state.copyWith(status: HubStatus.success, profile: profile));
    } catch (e) {
      const fallbackMessage = 'Не удалось получить профиль хаба';
      emit(state.copyWith(
        status: HubStatus.failure,
        error: ExceptionHelper.parseMessage(e, fallbackMessage),
      ));
    }
  }
}
