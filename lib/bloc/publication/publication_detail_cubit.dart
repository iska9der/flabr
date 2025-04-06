import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';
import '../../presentation/extension/extension.dart';

part 'publication_detail_state.dart';

class PublicationDetailCubit extends Cubit<PublicationDetailState> {
  PublicationDetailCubit(
    String id, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       super(
         PublicationDetailState(
           id: id,
           source: source,
           publication: Publication.empty,
         ),
       );

  final PublicationRepository _repository;

  void fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: PublicationStatus.loading));

    try {
      final publication = await _repository.fetchPublicationById(
        state.id,
        source: state.source,
      );

      emit(
        state.copyWith(
          status: PublicationStatus.success,
          publication: publication,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PublicationStatus.failure,
          error: e.parseException(),
        ),
      );

      rethrow;
    }
  }
}
