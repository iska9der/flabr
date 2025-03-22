import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/publication/publication.dart';
import '../../../data/repository/repository.dart';

enum PublicationListStatus { initial, loading, success, failure }

/// Абстрактный класс для кубита списка публикаций
abstract class PublicationListCubit<State extends PublicationListState>
    extends Cubit<State> {
  PublicationListCubit(
    super.initialState, {
    required this.repository,
    required this.languageRepository,
  }) {
    _uiLangSub = languageRepository.uiStream.listen((_) => refetch());
    _articleLangsSub = languageRepository.articlesStream.listen(
      (_) => refetch(),
    );
  }

  final PublicationRepository repository;
  final LanguageRepository languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articleLangsSub;

  /// Показывать тип поста в карточках
  bool get showType => false;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articleLangsSub.cancel();

    return super.close();
  }

  bool get fetchDisabled =>
      state.status == PublicationListStatus.loading ||
      !state.isFirstFetch && state.isLastPage ||
      state.isFirstFetch && state.status == PublicationListStatus.failure;

  /// Получение списка публикаций
  FutureOr<void> fetch();

  /// Переполучить список с первой страницы
  FutureOr<void> refetch();
}

/// Абстрактный класс для стейта списка публикаций
abstract class PublicationListState {
  const PublicationListState({
    required this.status,
    required this.error,
    required this.page,
    required this.pagesCount,
    required this.publications,
  });

  final PublicationListStatus status;
  final String error;
  final int page;
  final int pagesCount;
  final List<Publication> publications;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= pagesCount;
}
