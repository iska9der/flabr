import 'package:equatable/equatable.dart';

import '../../../common/cubit/publication_list.dart';
import '../../../common/exception/exception_helper.dart';
import '../../../common/model/network/list_response.dart';
import '../../publication/model/publication/publication.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';

part 'user_bookmark_list_state.dart';

class UserBookmarkListCubit extends PublicationListC<UserBookmarkListState> {
  UserBookmarkListCubit({
    required PublicationRepository repository,
    required LanguageRepository languageRepository,
    String user = '',
    PublicationType type = PublicationType.article,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(UserBookmarkListState(
          user: user,
          type: type,
        ));

  final PublicationRepository _repository;
  final LanguageRepository _languageRepository;

  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
    ));
  }

  @override
  Future<void> fetch() async {
    if (state.status == PublicationListStatus.loading ||
        !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await _repository.fetchUserBookmarks(
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
        user: state.user,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
        status: PublicationListStatus.failure,
      ));

      rethrow;
    }
  }
}
