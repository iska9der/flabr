import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'publication_counters_bloc.freezed.dart';
part 'publication_counters_event.dart';
part 'publication_counters_state.dart';

class PublicationCountersBloc
    extends Bloc<PublicationCountersEvent, PublicationCountersState> {
  PublicationCountersBloc({required this._repository})
    : super(const PublicationCountersState()) {
    on<PublicationCountersEvent>(
      (event, emit) => switch (event) {
        LoadEvent event => _fetch(event, emit),
      },
    );
  }

  final PublicationRepository _repository;

  FutureOr<void> _fetch(
    LoadEvent event,
    Emitter<PublicationCountersState> emit,
  ) async {
    if (state.status == LoadingStatus.loading) {
      return;
    }

    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final result = await _repository.fetchCounters();

      emit(state.copyWith(status: LoadingStatus.success, counters: result));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: AppFailure(.publicationCountersFetchFailed, e),
        ),
      );
    }
  }
}
