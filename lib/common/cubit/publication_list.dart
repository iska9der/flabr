import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/publication/model/publication/publication.dart';
import '../../feature/publication/repository/publication_repository.dart';
import '../../feature/settings/repository/language_repository.dart';

enum PublicationListStatus { initial, loading, success, failure }

abstract class PublicationListC<State extends PublicationListS>
    extends Cubit<State> {
  PublicationListC(
    super.initialState, {
    required this.repository,
    required this.languageRepository,
  }) {
    _uiLangSub = languageRepository.uiStream.listen(
      (_) => refetch(),
    );
    _articleLangsSub = languageRepository.articlesStream.listen(
      (_) => refetch(),
    );
  }

  final PublicationRepository repository;
  final LanguageRepository languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articleLangsSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articleLangsSub.cancel();

    return super.close();
  }

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  /// Получение списка публикаций
  FutureOr<void> fetch();

  /// Переполучить список с первой страницы
  FutureOr<void> refetch();
}

abstract interface class PublicationListS {
  PublicationListStatus get status;
  String get error;
  int get page;
  int get pagesCount;
  List<Publication> get publications;
}
