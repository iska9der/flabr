import 'dart:async';

import 'package:injectable/injectable.dart';

import '../model/comment/comment.dart';
import '../model/filter/filter.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/section_enum.dart';
import '../model/user/user.dart';
import '../service/service.dart';

@LazySingleton()
class PublicationRepository {
  PublicationRepository(this.service);

  final PublicationService service;

  Future<PublicationCounters> fetchCounters() async {
    final rawData = await service.fetchCounters();

    final counters = PublicationCounters.fromJson(rawData);

    return counters;
  }

  Future<Publication> fetchPublicationById(
    String id, {
    required PublicationSource source,
  }) async {
    return switch (source) {
      PublicationSource.post => await _fetchPostById(id),
      _ => await _fetchCommonById(id),
    };
  }

  Future<PublicationCommon> _fetchCommonById(String id) async {
    final rawData = await service.fetchArticleById(id);

    final publication = PublicationCommon.fromMap(rawData);

    return publication;
  }

  Future<PublicationPost> _fetchPostById(String id) async {
    final rawData = await service.fetchPostById(id);

    final post = PublicationPost.fromMap(rawData);

    return post;
  }

  /// Сортируем статьи в полученном списке
  List<Publication> _sortListResponse(
    Sort sort,
    ListResponse<Publication> response,
  ) {
    final List<Publication> refs = [...response.refs];

    if (sort == Sort.byBest) {
      refs.sort((a, b) => b.statistics.score.compareTo(a.statistics.score));
    } else {
      refs.sort((a, b) => b.timePublished.compareTo(a.timePublished));
    }

    return refs;
  }

  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required FeedFilter filter,
  }) async {
    var response = await service.fetchFeed(
      page: page,
      score: filter.score.value.isEmpty ? 'all' : filter.score.value,
      types: filter.types.map((t) => t.name).toList(),
    );

    final sortedList = _sortListResponse(Sort.byNew, response);
    response = response.copyWith(refs: sortedList);

    return response;
  }

  /// Получение статей/новостей/постов
  ///
  /// Сортировка полученных статей происходит как на сайте:
  /// если сортировка по лучшим [Sort.byBest], то надо сортировать по рейтингу;
  /// если по новым [Sort.byNew], сортируем по дате публикации
  ///
  Future<ListResponse<Publication>> fetchFlowArticles({
    required Section section,
    required PublicationFlow flow,
    required FlowFilter filter,
    required String page,
  }) async {
    var response = await service.fetchFlowArticles(
      section: section,
      flow: flow,
      sort: filter.sort,
      period: filter.period,
      score: filter.score,
      page: page,
    );

    final sortedList = _sortListResponse(filter.sort, response);
    response = response.copyWith(refs: sortedList);

    return response;
  }

  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required FlowFilter filter,
    required String page,
  }) async {
    var response = await service.fetchHubArticles(
      hub: hub,
      sort: filter.sort,
      period: filter.period,
      score: filter.score,
      page: page,
    );

    final sortedList = _sortListResponse(filter.sort, response);
    response = response.copyWith(refs: sortedList);

    return response;
  }

  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    var response = await service.fetchUserPublications(
      user: user,
      page: page,
      type: type,
    );

    final sortedList = _sortListResponse(Sort.byNew, response);
    response = response.copyWith(refs: sortedList);

    return response;
  }

  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async {
    final response = await service.fetchUserBookmarks(
      user: user,
      page: page,
      type: type,
    );

    var newResponse = response.copyWith(
      refs:
          response.ids
              .map((id) => response.refs.firstWhere((ref) => id == ref.id))
              .toList(),
    );

    return newResponse;
  }

  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
  }) async {
    var listResponse = await service.fetchComments(
      articleId: articleId,
      source: source,
    );

    final structComments = listResponse.structurizeComments();
    listResponse = listResponse.copyWith(comments: structComments);

    return listResponse;
  }

  Future<bool> addToBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    return await service.addToBookmark(id: id, source: source);
  }

  Future<bool> removeFromBookmark({
    required String id,
    required PublicationSource source,
  }) async {
    return await service.removeFromBookmark(id: id, source: source);
  }

  Future<List<PublicationCommon>> fetchMostReading() async {
    final raw = await service.fetchMostReading();

    List<PublicationCommon> publications =
        [...raw.refs]
          ..sort(
            (a, b) =>
                a.statistics.readingCount > b.statistics.readingCount ? 0 : 1,
          )
          ..take(8).toList();

    return publications;
  }
}
