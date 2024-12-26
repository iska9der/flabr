import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/repository/part.dart';

part 'tracker_publications_marker_bloc.freezed.dart';
part 'tracker_publications_marker_event.dart';
part 'tracker_publications_marker_state.dart';

class TrackerPublicationsMarkerBloc extends Bloc<TrackerPublicationsMarkerEvent,
    TrackerPublicationsMarkerState> {
  TrackerPublicationsMarkerBloc({required this.repository})
      : super(const TrackerPublicationsMarkerState()) {
    on<MarkEvent>(_mark);
    on<RemoveEvent>(_delete);
    on<ReadEvent>(_read);
  }

  final TrackerRepository repository;

  FutureOr<void> _mark(
    MarkEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) {
    Map<String, bool> newSet;

    if (event.isMarked) {
      newSet = {
        ...state.markedIds,
        ...{event.id: event.isUnreaded}
      };
    } else {
      newSet = Map.from(state.markedIds)..remove(event.id);
    }

    emit(state.copyWith(markedIds: newSet));
  }

  FutureOr<void> _read(
    ReadEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) async {
    try {
      await repository.readPublications(
        List<String>.from(state.markedIds.keys),
      );

      emit(state.copyWith(status: LoadingStatus.success, markedIds: {}));
    } catch (e, trace) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: 'Не удалось отметить публикации как прочитанные',
      ));

      Error.throwWithStackTrace(e, trace);
    }
  }

  FutureOr<void> _delete(
    RemoveEvent event,
    Emitter<TrackerPublicationsMarkerState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await repository.deletePublications(
        List<String>.from(state.markedIds.keys),
      );

      emit(state.copyWith(status: LoadingStatus.success, markedIds: {}));
    } catch (e, trace) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: 'Не удалось удалить публикации из трекера',
      ));

      Error.throwWithStackTrace(e, trace);
    }
  }
}
