import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/hub/hub.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/repository/repository.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit(String alias, {required HubRepository repository})
    : _repository = repository,
      super(HubState(alias: alias));

  final HubRepository _repository;

  void fetchProfile() async {
    HubProfile profile = state.profile;

    try {
      if (profile.isEmpty) {
        emit(state.copyWith(status: .loading));

        profile = await _repository.fetchProfile(state.alias);
      }

      emit(state.copyWith(status: .success, profile: profile));
    } catch (e) {
      const fallbackMessage = 'Не удалось получить профиль хаба';
      emit(
        state.copyWith(
          status: .failure,
          error: e.parseException(fallbackMessage),
        ),
      );
    }
  }
}
