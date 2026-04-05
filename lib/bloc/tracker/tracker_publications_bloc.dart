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
  TrackerPublicationsBloc({required TrackerPublicationRepository repository})
    : _repository = repository,
      super(const TrackerPublicationsState()) {
    on<TrackerPublicationsEvent>(
      (event, emit) => switch (event) {
        _SubscribeEvent event => _onSubscribe(event, emit),
        _LoadEvent event => _onLoad(event, emit),
        _LoadedEvent event => _onLoaded(event, emit),
      },
    );
  }

  final TrackerPublicationRepository _repository;
  StreamSubscription<ListResponse<TrackerPublication>>? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onSubscribe(
    _SubscribeEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) async {
    await _subscription?.cancel();

    _subscription = _repository.getPublications().listen(
      (response) => add(.loaded(response)),
    );
  }

  FutureOr<void> _onLoad(
    _LoadEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    try {
      await _repository.fetchPublications(page: state.page.toString());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: error.parseException('Не удалось получить публикации'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  FutureOr<void> _onLoaded(
    _LoadedEvent event,
    Emitter<TrackerPublicationsState> emit,
  ) {
    emit(state.copyWith(status: .success, response: event.response));
  }
}
