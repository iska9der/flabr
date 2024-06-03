import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/exception/part.dart';
import '../../../data/repository/part.dart';
import '../../../presentation/extension/part.dart';
import '../model/publication/publication.dart';
import '../model/source/publication_source.dart';

part 'publication_detail_state.dart';

class PublicationDetailCubit extends Cubit<PublicationDetailState> {
  PublicationDetailCubit(
    String id, {
    required PublicationSource source,
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(PublicationDetailState(
          id: id,
          source: source,
          publication: Publication.empty,
        )) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => _reInit(),
    );
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final PublicationRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articlesLangSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articlesLangSub.cancel();

    return super.close();
  }

  void fetch() async {
    if (state.status.isLoading) return;

    emit(state.copyWith(status: PublicationStatus.loading));

    try {
      final publication = await _repository.fetchPublicationById(
        state.id,
        source: state.source,
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
      );

      emit(state.copyWith(
        status: PublicationStatus.success,
        publication: publication,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PublicationStatus.failure,
        error: ExceptionHelper.parseMessage(e),
      ));

      rethrow;
    }
  }

  void _reInit() {
    emit(state.copyWith(status: PublicationStatus.initial));
  }
}
