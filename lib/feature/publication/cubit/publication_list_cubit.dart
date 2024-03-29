import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../settings/repository/language_repository.dart';
import '../model/publication/publication.dart';
import '../model/sort/date_period_enum.dart';
import '../model/sort/sort_enum.dart';
import '../model/sort/sort_option_model.dart';
import '../repository/publication_repository.dart';

enum PublicationListStatus { initial, loading, success, failure }

/// Абстрактный класс для кубита списка публикаций
abstract class PublicationListCubit<S extends PublicationListState>
    extends Cubit<S> {
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

/// Абстрактный класс для кубита списка публикаций
/// с возможностью сортировки
abstract class SortablePublicationListCubit<
    S extends SortablePublicationListState> extends PublicationListCubit<S> {
  SortablePublicationListCubit(
    super.initialState, {
    required super.repository,
    required super.languageRepository,
  });

  void changeSort(SortEnum sort);
  void changeSortOption(SortEnum sort, SortOptionModel option);
}

/// Интерфейс для стейта списка публикаций с возможностью сортировки
abstract interface class SortablePublicationListState
    implements PublicationListState {
  SortEnum get sort;
  DatePeriodEnum get period;
  String get score;
}
