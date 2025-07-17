import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/exception/exception.dart';
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
      (event, emit) => switch (event) {
        LoadEvent event => _fetch(event, emit),
        SubscribeEvent event => _subscribe(event, emit),
      },
    );
  }

  final TrackerRepository repository;

  Future<void> _subscribe(
    SubscribeEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    await emit.forEach(
      repository.getNotifications(category: state.category),
      onData:
          (data) =>
              state.copyWith(status: LoadingStatus.success, response: data),
    );
  }

  FutureOr<void> _fetch(
    LoadEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    try {
      await repository.fetchNotifications(
        page: state.page.toString(),
        category: state.category,
      );
    } catch (error, trace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: error.parseException('Не удалось получить уведомления'),
        ),
      );

      super.onError(error, trace);
    }
  }
}
