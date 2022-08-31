import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/hub_model.dart';
import '../model/hub_profile_model.dart';
import '../service/hub_service.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit(
    String alias, {
    required HubService service,
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(
            HubState(alias: alias, langUI: langUI, langArticles: langArticles));

  final HubService _service;

  void fetchProfile() async {
    HubProfileModel profile = state.profile;

    try {
      if (profile.isEmpty) {
        emit(state.copyWith(status: HubStatus.loading));

        profile = await _service.fetchProfile(
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
