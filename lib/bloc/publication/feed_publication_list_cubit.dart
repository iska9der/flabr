import 'package:equatable/equatable.dart';

import '../../data/exception/exception.dart';
import '../../data/model/filter/filter.dart';
import '../../data/model/list_response_model.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../feature/publication_list/publication_list.dart';

part 'feed_publication_list_state.dart';

class FeedPublicationListCubit
    extends PublicationListCubit<FeedPublicationListState> {
  FeedPublicationListCubit({
    required super.repository,
    required super.languageRepository,
  }) : super(const FeedPublicationListState()) {
    _restoreFilter();
  }

  Future<void> _restoreFilter() async {
    emit(state.copyWith(status: .loading));

    FeedPublicationListState newState = state;
    final lastFilter = await repository.restoreFeedFilter();
    if (lastFilter != null) {
      newState = newState.copyWith(filter: lastFilter);
    }

    emit(newState.copyWith(status: .initial));
  }

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: .loading));

    try {
      final response = await repository.fetchFeed(
        page: state.page.toString(),
        filter: state.filter,
      );

      emit(
        state.copyWith(
          status: .success,
          response: state.response.merge(response, getId: (ref) => ref.id),
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.parseException('Не удалось получить публикации'),
          status: .failure,
        ),
      );

      rethrow;
    }
  }

  @override
  void reset() {
    emit(FeedPublicationListState(filter: state.filter));
  }

  void applyFilter(FeedFilter newFilter) {
    if (state.filter == newFilter) {
      return;
    }

    repository.saveFeedFilter(newFilter);

    emit(FeedPublicationListState(filter: newFilter));
  }
}
