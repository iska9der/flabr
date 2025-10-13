import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/exception/exception.dart';
import '../../../../../data/model/list_response_model.dart';
import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/model/tracker/tracker.dart';
import '../../../../../data/repository/repository.dart';

part 'tracker_publications_bloc.freezed.dart';
part 'tracker_publications_event.dart';
part 'tracker_publications_state.dart';

class TrackerPublicationsBloc
    extends Bloc<TrackerPublicationsEvent, TrackerPublicationsState> {
  TrackerPublicationsBloc({required this.repository})
    : super(const TrackerPublicationsState()) {
    on<TrackerPublicationsEvent>(
      (event, emit) => switch (event) {
        SubscribeEvent event => _subscribe(event, emit),
        LoadEvent event => _fetch(event, emit),
      },
    );
  }

  final TrackerRepository repository;

  Future<void> _subscribe(
    SubscribeEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    await emit.forEach(
      repository.getPublications(),
      onData:
          (data) => state.copyWith(
            status: LoadingStatus.success,
            response: data,
          ),
    );
  }

  FutureOr<void> _fetch(
    LoadEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) async {
    try {
      await repository.fetchPublications(page: state.page.toString());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: error.parseException('Не удалось получить публикации'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
