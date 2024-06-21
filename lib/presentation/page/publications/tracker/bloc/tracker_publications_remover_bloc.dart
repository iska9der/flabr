import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/repository/part.dart';

part 'tracker_publications_remover_bloc.freezed.dart';
part 'tracker_publications_remover_event.dart';
part 'tracker_publications_remover_state.dart';

class TrackerPublicationsRemoverBloc extends Bloc<
    TrackerPublicationsRemoverEvent, TrackerPublicationsRemoverState> {
  TrackerPublicationsRemoverBloc({required this.repository})
      : super(const TrackerPublicationsRemoverState()) {
    on<MarkEvent>(mark);
    on<RemoveEvent>(delete);
  }

  final TrackerRepository repository;

  FutureOr<void> mark(
    MarkEvent event,
    Emitter<TrackerPublicationsRemoverState> emit,
  ) {
    Set<String> newSet;
    if (event.isMarked) {
      newSet = {...state.markedIds, event.id};
    } else {
      newSet = Set.from(state.markedIds)..remove(event.id);
    }

    emit(state.copyWith(markedIds: newSet));
  }

  FutureOr<void> delete(
    RemoveEvent event,
    Emitter<TrackerPublicationsRemoverState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await repository.deletePublications(
        List<String>.from(state.markedIds),
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
