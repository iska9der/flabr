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
    required TrackerNotificationRepository repository,
    required TrackerNotificationCategory category,
  }) : _repository = repository,
       super(TrackerNotificationsState(category: category)) {
    on<TrackerNotificationsEvent>(
      (event, emit) => switch (event) {
        _LoadEvent event => _onLoad(event, emit),
        _SubscribeEvent event => _onSubscribe(event, emit),
        _LoadedEvent event => _onLoaded(event, emit),
      },
    );
  }

  final TrackerNotificationRepository _repository;
  StreamSubscription<ListResponse<TrackerNotification>>? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onSubscribe(
    _SubscribeEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    await _subscription?.cancel();

    _subscription = _repository
        .onChange(category: state.category)
        .listen((response) => add(.loaded(response)));
  }

  FutureOr<void> _onLoad(
    _LoadEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    try {
      await _repository.fetchNotifications(
        page: state.page.toString(),
        category: state.category,
      );
    } catch (error, trace) {
      emit(
        state.copyWith(
          status: .failure,
          error: error.parseException('Не удалось получить уведомления'),
        ),
      );

      super.onError(error, trace);
    }
  }

  FutureOr<void> _onLoaded(
    _LoadedEvent event,
    Emitter<TrackerNotificationsState> emit,
  ) {
    emit(state.copyWith(status: .success, response: event.response));
  }
}
