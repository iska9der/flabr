import 'package:injectable/injectable.dart';

import '../../core/constants/environment.dart';
import '../demo/demo_publications.dart';
import '../model/comment/comment.dart';
import '../model/filter/filter.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/section_enum.dart';
import '../model/user/user.dart';
import '../repository/language_repository.dart';
import 'publication_service.dart';

/// Локальный источник фрагмента статьи и демоновости без сетевых запросов
@demo
@LazySingleton(as: PublicationService)
class DemoPublicationService implements PublicationService {
  const DemoPublicationService(this._languageRepository);

  final LanguageRepository _languageRepository;

  /// Дата среза демобиблиотеки: фильтры не зависят от часов устройства
  static final _snapshotAt = DateTime.utc(2017, 8, 11, 12);

  /// Демокаталог следует языку интерфейса, не меняя языки обычных публикаций
  Iterable<DemoPublication> get _selected {
    final language = _languageRepository.lastUI;
    return demoPublications.where((entry) => entry.language == language);
  }

  PublicationCommon _article(String id) {
    for (final entry in _selected) {
      if (entry.publication.id == id) return entry.publication;
    }
    throw ArgumentError.value(id, 'id', 'Unknown demo publication');
  }

  ListResponse<Publication> _page(
    Iterable<PublicationCommon> publications,
    String page,
  ) {
    final number = int.tryParse(page);
    if (number == null || number < 1) {
      throw ArgumentError.value(
        page,
        'page',
        'Expected a positive page number',
      );
    }
    final refs = publications.toList(growable: false);
    final pagesCount = refs.isEmpty ? 0 : 1;
    if (number > 1) {
      return ListResponse<Publication>(pagesCount: pagesCount);
    }
    return ListResponse<Publication>(
      pagesCount: pagesCount,
      ids: refs.map((publication) => publication.id).toList(growable: false),
      refs: refs,
    );
  }

  List<PublicationCommon> _ranked(
    Iterable<PublicationCommon> publications, {
    required String score,
    Sort sort = Sort.byNew,
    String period = 'alltime',
  }) {
    final minimum = switch (score) {
      '' || 'all' => null,
      _ =>
        int.tryParse(score) ??
            (throw ArgumentError.value(score, 'score', 'Unknown demo score')),
    };
    final days = sort == Sort.byBest
        ? switch (period) {
            'daily' => 1,
            'weekly' => 7,
            'monthly' => 31,
            'yearly' => 365,
            'alltime' => null,
            _ => throw ArgumentError.value(
              period,
              'period',
              'Unknown demo period',
            ),
          }
        : null;
    final cutoff = days == null
        ? null
        : _snapshotAt.subtract(Duration(days: days));
    final refs = publications.where((publication) {
      return (minimum == null || publication.statistics.score >= minimum) &&
          (cutoff == null ||
              !DateTime.parse(publication.timePublished).isBefore(cutoff));
    }).toList();
    refs.sort((a, b) {
      if (sort == Sort.byBest) {
        final ranking = b.statistics.score.compareTo(a.statistics.score);
        if (ranking != 0) return ranking;
      }
      final date = b.timePublished.compareTo(a.timePublished);
      return date != 0 ? date : a.id.compareTo(b.id);
    });
    return refs;
  }

  @override
  Future<PublicationCounters> fetchCounters() async {
    var articles = 0;
    var news = 0;
    for (final entry in _selected) {
      if (entry.publication.type == PublicationType.article) articles++;
      if (entry.publication.type == PublicationType.news) news++;
    }
    return PublicationCounters(articles: articles, news: news);
  }

  @override
  Future<PublicationCommon> fetchArticleById(String id) async => _article(id);

  @override
  Future<PublicationPost> fetchPostById(String id) async =>
      throw ArgumentError.value(id, 'id', 'No posts in the demo library');

  @override
  Future<ListResponse<Publication>> fetchFeed({
    required String page,
    required String score,
    required List<String> types,
  }) async {
    final selectedTypes = types
        .map(
          (type) => switch (type) {
            'articles' => PublicationType.article,
            'news' => PublicationType.news,
            'posts' => PublicationType.post,
            _ => throw ArgumentError.value(
              type,
              'types',
              'Unknown demo publication type',
            ),
          },
        )
        .toSet();
    final publications = _selected
        .map((entry) => entry.publication)
        .where(
          (publication) =>
              types.isEmpty || selectedTypes.contains(publication.type),
        );
    return _page(_ranked(publications, score: score), page);
  }

  @override
  Future<ListResponse<Publication>> fetchFlowArticles({
    required Section section,
    required PublicationFlow flow,
    required Sort sort,
    required String page,
    required FilterOption period,
    required FilterOption score,
  }) async {
    final type = switch (section) {
      Section.article => PublicationType.article,
      Section.news => PublicationType.news,
      Section.post => PublicationType.post,
    };
    final publications = _selected
        .where((entry) {
          return entry.publication.type == type &&
              (flow == PublicationFlow.all || entry.flow == flow);
        })
        .map((entry) => entry.publication);
    return _page(
      _ranked(
        publications,
        score: score.value,
        sort: sort,
        period: period.value,
      ),
      page,
    );
  }

  @override
  Future<ListResponse<Publication>> fetchHubArticles({
    required String hub,
    required Sort sort,
    required FilterOption period,
    required FilterOption score,
    required String page,
  }) async {
    final publications = _selected
        .map((entry) => entry.publication)
        .where(
          (publication) => publication.hubs.any((item) => item.alias == hub),
        );
    return _page(
      _ranked(
        publications,
        score: score.value,
        sort: sort,
        period: period.value,
      ),
      page,
    );
  }

  @override
  Future<ListResponse<Publication>> fetchUserPublications({
    required String user,
    required String page,
    required UserPublicationType type,
  }) async {
    final publicationType = switch (type) {
      UserPublicationType.articles => PublicationType.article,
      UserPublicationType.news => PublicationType.news,
      UserPublicationType.posts => PublicationType.post,
    };
    final publications = _selected
        .map((entry) => entry.publication)
        .where(
          (publication) =>
              publication.author.alias == user &&
              publication.type == publicationType,
        );
    return _page(_ranked(publications, score: ''), page);
  }

  @override
  Future<ListResponse<Publication>> fetchUserBookmarks({
    required String user,
    required String page,
    required UserBookmarksType type,
  }) async => _page(const [], page);

  @override
  Future<CommentListResponse> fetchComments({
    required String articleId,
    required PublicationSource source,
  }) async {
    final publication = _article(articleId);
    if (PublicationSource.fromType(publication.type) != source) {
      throw ArgumentError.value(
        source,
        'source',
        'Wrong demo publication source',
      );
    }
    return const CommentListResponse();
  }

  @override
  Future<MostReadingResponse> fetchMostReading() async {
    final refs = _selected.map((entry) => entry.publication).toList()
      ..sort((a, b) {
        final ranking = b.statistics.readingCount.compareTo(
          a.statistics.readingCount,
        );
        return ranking != 0 ? ranking : a.id.compareTo(b.id);
      });
    return MostReadingResponse(
      pagesCount: refs.isEmpty ? 0 : 1,
      ids: refs.map((publication) => publication.id).toList(growable: false),
      refs: refs,
    );
  }

  @override
  Future<bool> addToBookmark({
    required String id,
    required PublicationSource source,
  }) async => throw UnsupportedError('Bookmarks are unavailable in demo mode');

  @override
  Future<bool> removeFromBookmark({
    required String id,
    required PublicationSource source,
  }) async => throw UnsupportedError('Bookmarks are unavailable in demo mode');

  @override
  Future<PublicationVoteResponse> voteUp(String articleId) async =>
      throw UnsupportedError('Voting is unavailable in demo mode');

  @override
  Future<PublicationVoteResponse> voteDown(String articleId) async =>
      throw UnsupportedError('Voting is unavailable in demo mode');
}
