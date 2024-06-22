import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/model/tracker/part.dart';
import '../../../../../data/repository/part.dart';

part 'tracker_publications_bloc.freezed.dart';
part 'tracker_publications_event.dart';
part 'tracker_publications_state.dart';

class TrackerPublicationsBloc
    extends Bloc<TrackerPublicationsEvent, TrackerPublicationsState> {
  TrackerPublicationsBloc({required this.repository})
      : super(const TrackerPublicationsState()) {
    on<LoadEvent>(fetch);
  }

  final TrackerRepository repository;

  FutureOr<void> fetch(
    LoadEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) async {
    if (state.status == LoadingStatus.loading) {
      return;
    }

    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final result = await repository.fetchPublications(
        page: state.page.toString(),
      );

      emit(state.copyWith(status: LoadingStatus.success, response: result));
    } catch (e, trace) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: 'Не удалось получить публикации',
      ));

      Error.throwWithStackTrace(e, trace);
    }
  }
}
