import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/exception/exception.dart';
import '../../../data/model/publication/publication.dart';
import '../airplane.dart';

part 'offline_publication_list_bloc.freezed.dart';
part 'offline_publication_list_event.dart';
part 'offline_publication_list_state.dart';

class OfflinePublicationListBloc
    extends Bloc<OfflinePublicationListEvent, OfflinePublicationListState> {
  OfflinePublicationListBloc({required OfflinePublicationRepository repository})
    : _repository = repository,
      super(const OfflinePublicationListState.initial()) {
    on<_LoadEvent>(_onLoad);
  }

  final OfflinePublicationRepository _repository;

  Future<void> _onLoad(
    _LoadEvent event,
    Emitter<OfflinePublicationListState> emit,
  ) async {
    emit(const OfflinePublicationListState.loading());

    await emit.forEach(
      _repository.watchAll(),
      onData: (data) => OfflinePublicationListState.success(models: data),
      onError: (error, stackTrace) {
        super.onError(error, stackTrace);

        final prevModels = state.maybeWhen<List<Publication>>(
          success: (models) => models,
          failure: (models, _) => models,
          orElse: () => [],
        );

        return OfflinePublicationListState.failure(
          models: prevModels,
          error: error.parseException(),
        );
      },
    );
  }
}
