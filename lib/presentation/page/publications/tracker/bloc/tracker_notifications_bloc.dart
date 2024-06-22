import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/model/loading_status_enum.dart';
import '../../../../../data/model/tracker/part.dart';
import '../../../../../data/repository/part.dart';

part 'tracker_notifications_bloc.freezed.dart';
part 'tracker_notifications_event.dart';
part 'tracker_notifications_state.dart';

class TrackerNotificationsBloc
    extends Bloc<TrackerNotificationsEvent, TrackerNotificationsState> {
  TrackerNotificationsBloc({
    required this.repository,
    required TrackerNotificationCategory category,
  }) : super(TrackerNotificationsState(category: category)) {
    on<LoadEvent>(fetch);
  }

  final TrackerRepository repository;

  FutureOr<void> fetch(
    LoadEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    try {
      final result = await repository.fetchNotifications(
        page: state.page.toString(),
        category: state.category,
      );

      emit(state.copyWith(status: LoadingStatus.success, response: result));
    } catch (e, trace) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: 'Не удалось получить уведомления',
      ));

      Error.throwWithStackTrace(e, trace);
    }
  }
}
