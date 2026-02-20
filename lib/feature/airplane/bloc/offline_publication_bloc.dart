import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/model/publication/publication.dart';
import '../database/database.dart';

part 'offline_publication_bloc.freezed.dart';
part 'offline_publication_event.dart';
part 'offline_publication_state.dart';

class OfflinePublicationBloc
    extends Bloc<OfflinePublicationEvent, OfflinePublicationState> {
  OfflinePublicationBloc({required PublicationDao repository})
    : _repository = repository,
      super(const OfflinePublicationState.initial()) {
    on<_CreateEvent>(_onCreate);
    on<_DeleteEvent>(_onDelete);
  }

  PublicationDao _repository;

  Future<void> _onCreate(
    _CreateEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    emit(const OfflinePublicationState.loading());

    try {
      await _repository.insertPublication(event.publication);

      emit(const OfflinePublicationState.success());
    } catch (error, stackTrace) {
      emit(OfflinePublicationState.failure(error: error.toString()));

      super.onError(error, stackTrace);
    }
  }

  Future<void> _onDelete(
    _DeleteEvent event,
    Emitter<OfflinePublicationState> emit,
  ) async {
    emit(const OfflinePublicationState.loading());

    try {
      await _repository.deletePublication(event.id);

      emit(const OfflinePublicationState.success());
    } catch (error, stackTrace) {
      emit(OfflinePublicationState.failure(error: error.toString()));

      super.onError(error, stackTrace);
    }
  }
}
