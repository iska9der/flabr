import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../../data/exception/exception.dart';
import '../../data/model/filter/filter.dart';
import '../../data/model/publication/publication.dart';
import '../../feature/publication_list/publication_list.dart';

part 'feed_publication_list_state.dart';

class FeedPublicationListCubit
    extends PublicationListCubit<FeedPublicationListState> {
  FeedPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    required this.storage,
  }) : super(const FeedPublicationListState()) {
    _restoreFilter();
  }

  final CacheStorage storage;

  Future<void> _restoreFilter() async {
    emit(state.copyWith(status: PublicationListStatus.loading));

    const key = CacheKeys.feedFilter;
    FeedPublicationListState newState = state;
    try {
      /// вспоминаем последний примененный фильтр в моей ленте
      final str = await storage.read(key);
      if (str == null) {
        throw const NotFoundException();
      }

      final lastFilter = FeedFilter.fromJson(jsonDecode(str));
      newState = newState.copyWith(filter: lastFilter);
    } catch (_) {
      storage.delete(key);
    } finally {
      emit(newState.copyWith(status: PublicationListStatus.initial));
    }
  }

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      final response = await repository.fetchFeed(
        page: state.page.toString(),
        filter: state.filter,
      );

      emit(
        state.copyWith(
          status: PublicationListStatus.success,
          publications: [...state.publications, ...response.refs],
          page: state.page + 1,
          pagesCount: response.pagesCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.parseException('Не удалось получить публикации'),
          status: PublicationListStatus.failure,
        ),
      );

      rethrow;
    }
  }

  @override
  void refetch() {
    emit(
      state.copyWith(
        status: PublicationListStatus.initial,
        page: 1,
        publications: [],
        pagesCount: 0,
      ),
    );
  }

  void applyFilter(FeedFilter newFilter) {
    if (state.filter == newFilter) {
      return;
    }

    storage.write(CacheKeys.feedFilter, jsonEncode(newFilter));

    emit(FeedPublicationListState(filter: newFilter));
  }
}
