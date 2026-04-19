import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';

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
    if (state.status == .loading) return;

    emit(state.copyWith(status: .loading));

    try {
      final publication = await _repository.fetchPublicationById(
        state.id,
        source: state.source,
      );

      emit(state.copyWith(status: .success, publication: publication));
    } catch (e) {
      emit(state.copyWith(status: .failure, error: e.parseException()));

      rethrow;
    }
  }
}
