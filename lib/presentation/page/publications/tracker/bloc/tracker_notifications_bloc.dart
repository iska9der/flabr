import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/list_response_model.dart';
import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/model/tracker/tracker.dart';
import '../../../../../data/repository/repository.dart';

part 'tracker_notifications_bloc.freezed.dart';
part 'tracker_notifications_event.dart';
part 'tracker_notifications_state.dart';

class TrackerNotificationsBloc
    extends Bloc<TrackerNotificationsEvent, TrackerNotificationsState> {
  TrackerNotificationsBloc({
    required this.repository,
    required TrackerNotificationCategory category,
  }) : super(TrackerNotificationsState(category: category)) {
    on<TrackerNotificationsEvent>(
      (event, emit) => event.map(
        load: (event) => _fetch(event, emit),
        read: (event) => _read(event, emit),
      ),
    );
  }

  final TrackerRepository repository;

  FutureOr<void> _fetch(
    LoadEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    try {
      final response = await repository.fetchNotifications(
        page: state.page.toString(),
        category: state.category,
      );

      final newUnreadIds =
          response.refs.where((e) => e.unread).map((e) => e.id).toSet();

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          response: response,
          unreadIds: newUnreadIds,
        ),
      );
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось получить уведомления',
        ),
      );

      Error.throwWithStackTrace(e, trace);
    }
  }

  FutureOr<void> _read(
    MarkAsReadEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    try {
      await repository.markAsReadNotifications(event.ids);

      final newUnreadIds = state.unreadIds.difference(Set.from(event.ids));

      emit(state.copyWith(unreadIds: newUnreadIds));
    } catch (e, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось отметить уведомления как прочитанные',
        ),
      );

      Error.throwWithStackTrace(e, trace);
    }
  }
}
