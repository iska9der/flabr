import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/repository/repository.dart';

part 'tracker_publications_marker_bloc.freezed.dart';
part 'tracker_publications_marker_event.dart';
part 'tracker_publications_marker_state.dart';

class TrackerPublicationsMarkerBloc
    extends
        Bloc<TrackerPublicationsMarkerEvent, TrackerPublicationsMarkerState> {
  TrackerPublicationsMarkerBloc({required this.repository})
    : super(const TrackerPublicationsMarkerState()) {
    on<TrackerPublicationsMarkerEvent>(
      (event, emit) => event.map(
        mark: (event) => _mark(event, emit),
        readMarked: (event) => _readMarked(event, emit),
        removeMarked: (event) => _removeMarked(event, emit),
        read: (event) => _read(event, emit),
      ),
    );
  }

  final TrackerRepository repository;

  FutureOr<void> _mark(
    MarkEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) {
    Map<String, bool> newMarkedIds;

    if (event.isMarked) {
      newMarkedIds = {
        ...state.markedIds,
        ...{event.id: event.isUnreaded},
      };
    } else {
      newMarkedIds = Map.from(state.markedIds)..remove(event.id);
    }

    emit(state.copyWith(markedIds: newMarkedIds));
  }

  FutureOr<void> _readMarked(
    ReadMarkedEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final ids = List<String>.from(
        state.markedIds.entries
            .where((element) => element.value == true)
            .map((e) => e.key),
      );

      await repository.markAsReadPublications(ids);

      emit(state.copyWith(status: LoadingStatus.success, markedIds: {}));
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось отметить публикации как прочитанные',
        ),
      );

      super.onError(e, trace);
    }
  }

  FutureOr<void> _removeMarked(
    RemoveMarkedEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final ids = List<String>.from(state.markedIds.keys);

      await repository.deletePublications(ids);

      emit(state.copyWith(status: LoadingStatus.success, markedIds: {}));
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось удалить публикации из трекера',
        ),
      );

      super.onError(e, trace);
    }
  }

  FutureOr<void> _read(
    ReadEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) {
    try {
      repository.readPublication(event.id);

      final newMarkedIds = Map<String, bool>.from(state.markedIds);
      if (newMarkedIds.keys.contains(event.id) &&
          newMarkedIds[event.id] == true) {
        newMarkedIds.update(event.id, (value) => false, ifAbsent: () => false);
      }

      emit(state.copyWith(markedIds: newMarkedIds));
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось прочесть публикацию',
        ),
      );

      super.onError(e, trace);
    }
  }
}
