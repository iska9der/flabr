import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/user/user.dart';
import '../../../data/repository/repository.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRepository repository,
  }) : _repository = repository,
       super(const ProfileState()) {
    on<_ResetEvent>(_onReset);
    on<_FetchMeEvent>(_onFetchMe);
    on<_FetchUpdatesEvent>(_onFetchUpdates);
  }

  final ProfileRepository _repository;

  FutureOr<void> _onReset(
    _ResetEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileState());
  }

  FutureOr<void> _onFetchMe(
    _FetchMeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.status == LoadingStatus.loading) return;

    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final me = await _repository.fetchMe();

      if (me == null) {
        throw const NotFoundException();
      }

      emit(state.copyWith(me: me, status: LoadingStatus.success));
    } catch (_) {
      emit(state.copyWith(me: UserMe.empty, status: LoadingStatus.failure));

      rethrow;
    }
  }

  FutureOr<void> _onFetchUpdates(
    _FetchUpdatesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final updates = await _repository.fetchUpdates();

      emit(state.copyWith(updates: updates));
    } catch (_) {
      rethrow;
    }
  }
}
