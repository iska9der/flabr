import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/language/language.dart';
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
    _uiLanguageSub = languageRepository.ui.listen((_) => refetch());
    _publicationLanguagesSub = languageRepository.publications.listen(
      (_) => refetch(),
    );
  }

  final PublicationRepository repository;
  final LanguageRepository languageRepository;

  late final StreamSubscription<Language> _uiLanguageSub;
  late final StreamSubscription<List<Language>> _publicationLanguagesSub;

  @override
  Future<void> close() {
    _uiLanguageSub.cancel();
    _publicationLanguagesSub.cancel();

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
