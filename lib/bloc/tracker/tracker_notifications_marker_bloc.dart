import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/model/tracker/tracker.dart';
import '../../../../../data/repository/repository.dart';

part 'tracker_notifications_marker_bloc.freezed.dart';
part 'tracker_notifications_marker_event.dart';
part 'tracker_notifications_marker_state.dart';

class TrackerNotificationsMarkerBloc
    extends
        Bloc<TrackerNotificationsMarkerEvent, TrackerNotificationsMarkerState> {
  TrackerNotificationsMarkerBloc({
    required this.repository,
    required TrackerNotificationCategory category,
  }) : super(TrackerNotificationsMarkerState(category: category)) {
    on<TrackerNotificationsMarkerEvent>(
      (event, emit) => switch (event) {
        MarkAsReadEvent event => _read(event, emit),
      },
    );
  }

  final TrackerRepository repository;

  FutureOr<void> _read(
    MarkAsReadEvent event,
    Emitter<TrackerNotificationsMarkerState> emit,
  ) async {
    if (state.status == LoadingStatus.loading) {
      return;
    }

    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await repository.markAsReadNotifications(
        category: state.category,
        ids: event.ids,
      );

      emit(state.copyWith(status: LoadingStatus.success));
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось отметить уведомления как прочитанные',
        ),
      );

      super.onError(e, trace);
    }
  }
}
