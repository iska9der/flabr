import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/hub_model.dart';
import '../model/hub_profile_model.dart';
import '../repository/hub_repository.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit(
    String alias, {
    required HubRepository repository,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _repository = repository,
        super(HubState(
          alias: alias,
          langUI: langUI,
          langArticles: langArticles,
        ));

  final HubRepository _repository;

  void fetchProfile() async {
    HubProfileModel profile = state.profile;

    try {
      if (profile.isEmpty) {
        emit(state.copyWith(status: HubStatus.loading));

        profile = await _repository.fetchProfile(
          state.alias,
          langUI: state.langUI,
          langArticles: state.langArticles,
        );
      }

      emit(state.copyWith(status: HubStatus.success, profile: profile));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: HubStatus.failure,
        error: e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HubStatus.failure,
        error: 'Не удалось получить профиль хаба',
      ));
    }
  }
}
