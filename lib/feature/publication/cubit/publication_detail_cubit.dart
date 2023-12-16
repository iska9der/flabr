import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../common/model/extension/enum_status.dart';
import '../../settings/repository/language_repository.dart';
import '../model/publication.dart';
import '../model/source/publication_source.dart';
import '../repository/publication_repository.dart';

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
      final publication = await _repository.fetchById(
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
