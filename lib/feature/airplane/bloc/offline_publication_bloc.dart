import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/publication/publication.dart';
import '../airplane.dart';

part 'offline_publication_bloc.freezed.dart';
part 'offline_publication_event.dart';
part 'offline_publication_state.dart';

class OfflinePublicationBloc
    extends Bloc<OfflinePublicationEvent, OfflinePublicationState> {
  OfflinePublicationBloc({required OfflinePublicationRepository repository})
    : _repository = repository,
      super(const OfflinePublicationState()) {
    on<_LoadEvent>(_onLoad);
    on<_ToggleEvent>(_onToggle);
  }

  final OfflinePublicationRepository _repository;

  Future<void> _onLoad(
    _LoadEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    await emit.forEach(
      _repository.watchAll(),
      onData: (data) {
        final ids = data.map((e) => e.id).toSet();

        return state.copyWith(idsInDb: ids, error: null);
      },
      onError: (error, stackTrace) {
        super.onError(error, stackTrace);

        return state.copyWith(error: error);
      },
    );
  }

  Future<void> _onToggle(
    _ToggleEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    final id = event.publication.id;
    final exists = state.idsInDb.contains(id);

    emit(state.copyWith(loadingIds: {...state.loadingIds, id}));

    try {
      switch (exists) {
        case true:
          await _repository.remove(id);
        case false:
          await _repository.save(event.publication);
      }

      emit(
        state.copyWith(
          loadingIds: {...state.loadingIds}..remove(id),
          error: null,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          loadingIds: {...state.loadingIds}..remove(id),
          error: error.parseException(),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
