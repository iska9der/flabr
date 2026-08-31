import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../bloc/error/app_failure.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/publication/publication.dart';
import '../model/publication_offline.dart';
import '../repository/repository.dart';

part 'offline_publication_bloc.freezed.dart';
part 'offline_publication_event.dart';
part 'offline_publication_state.dart';

class OfflinePublicationBloc
    extends Bloc<OfflinePublicationEvent, OfflinePublicationState> {
  OfflinePublicationBloc({required OfflinePublicationRepository repository})
    : _repository = repository,
      super(const OfflinePublicationState()) {
    on<_LoadEvent>(_onLoad);
    on<_SetSavedEvent>(_onSetSaved, transformer: sequential());
    on<_ChangedEvent>(_onChanged);
    on<_FailedEvent>(_onFailed);
  }

  final OfflinePublicationRepository _repository;
  StreamSubscription<List<PublicationOffline>>? _subscription;

  Future<void> _onLoad(
    _LoadEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading, error: null));
    await _subscription?.cancel();
    _subscription = _repository.watchSavedPublications().listen(
      (publications) => add(OfflinePublicationEvent.changed(publications)),
      onError: (Object error, StackTrace stackTrace) {
        add(OfflinePublicationEvent.failed(error, stackTrace));
      },
    );
  }

  Future<void> _onSetSaved(
    _SetSavedEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    final id = event.publication.id;
    if (state.loadingIds.contains(id)) return;

    emit(
      state.copyWith(
        loadingIds: {...state.loadingIds, id},
        operationError: null,
        operationErrorId: null,
      ),
    );
    try {
      if (event.saved) {
        await _repository.save(event.publication);
      } else {
        await _repository.remove(id);
      }
      emit(
        state.copyWith(
          loadingIds: {...state.loadingIds}..remove(id),
          operationError: null,
          operationErrorId: null,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          loadingIds: {...state.loadingIds}..remove(id),
          operationError: AppFailure(.operationFailed, error),
          operationErrorId: id,
        ),
      );
      super.onError(error, stackTrace);
    }
  }

  void _onChanged(
    _ChangedEvent event,
    Emitter<OfflinePublicationState> emit,
  ) {
    emit(
      state.copyWith(
        status: LoadingStatus.success,
        publications: event.publications,
        error: null,
      ),
    );
  }

  void _onFailed(_FailedEvent event, Emitter<OfflinePublicationState> emit) {
    emit(
      state.copyWith(
        status: LoadingStatus.failure,
        error: AppFailure(.operationFailed, event.error),
      ),
    );
    super.onError(event.error, event.stackTrace);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
