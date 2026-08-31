import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/language/language.dart';
import '../../../data/model/list_response_model.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/publication/publication.dart';
import '../../../data/repository/repository.dart';

/// Абстрактный класс для кубита списка публикаций
abstract class PublicationListCubit<State extends PublicationListState>
    extends Cubit<State> {
  PublicationListCubit(
    super.initialState, {
    required this.repository,
    required this.languageRepository,
    required this.settingsRepository,
  }) {
    _uiLanguageSub = languageRepository.onUIChange.listen((_) => reset());
    _publicationLanguagesSub = languageRepository.onPubUIChange.listen(
      (_) => reset(),
    );
  }

  final PublicationRepository repository;
  final LanguageRepository languageRepository;
  final SettingsRepository settingsRepository;

  late final StreamSubscription<Language> _uiLanguageSub;
  late final StreamSubscription<List<Language>> _publicationLanguagesSub;

  @override
  Future<void> close() {
    _uiLanguageSub.cancel();
    _publicationLanguagesSub.cancel();

    return super.close();
  }

  bool get fetchDisabled =>
      state.status == .loading ||
      state.response.pagesCount > 0 && state.isLastPage;

  /// Получение списка публикаций
  FutureOr<void> fetch();

  /// Переводит Cubit в пустое состояние указанной страницы с текущими фильтрами
  void reset({int page = 1});

  /// Очищает список для повторной загрузки
  void refresh() {
    final paginationEnabled =
        settingsRepository.lastConfig.feed.navigationMode == .pagination;

    reset(page: paginationEnabled ? state.currentPage : 1);
  }

  /// Загружает выбранную страницу без публикаций с других страниц
  void changePage(int page) {
    final pagesCount = state.response.pagesCount;
    final isOutOfRange = page < 1 || pagesCount > 0 && page > pagesCount;

    if (state.status == .loading || isOutOfRange || page == state.currentPage) {
      return;
    }

    reset(page: page);
  }
}

/// Абстрактный класс для стейта списка публикаций
abstract class PublicationListState {
  const PublicationListState({
    required this.status,
    required this.error,
    required this.page,
    required this.response,
  });

  final LoadingStatus status;
  final Object error;
  final int page;
  final ListResponse<Publication> response;

  bool get isFirstFetch => page == 1;
  int get currentPage => status == .success && page > 1 ? page - 1 : page;
  bool get isLastPage => currentPage >= response.pagesCount;
}
