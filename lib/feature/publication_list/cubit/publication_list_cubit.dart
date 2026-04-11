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
  }) {
    _uiLanguageSub = languageRepository.onUIChange.listen((_) => reset());
    _publicationLanguagesSub = languageRepository.onPubUIChange.listen(
      (_) => reset(),
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
      state.status == .loading || !state.isFirstFetch && state.isLastPage;

  /// Получение списка публикаций
  FutureOr<void> fetch();

  /// Сбросить состояние до начального
  FutureOr<void> reset();
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
  final String error;
  final int page;
  final ListResponse<Publication> response;

  bool get isFirstFetch => page == 1;
  bool get isLastPage => page >= response.pagesCount;
}
