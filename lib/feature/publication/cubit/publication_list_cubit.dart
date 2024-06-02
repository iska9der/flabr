import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/repository_part.dart';
import '../model/publication/publication.dart';

enum PublicationListStatus { initial, loading, success, failure }

/// Абстрактный класс для кубита списка публикаций
abstract class PublicationListCubit<State extends PublicationListState>
    extends Cubit<State> {
  PublicationListCubit(
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

  bool get showType => false;

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

/// Интерфейс для стейта списка публикаций
abstract interface class PublicationListState {
  PublicationListStatus get status;
  String get error;
  int get page;
  int get pagesCount;
  List<Publication> get publications;
}
