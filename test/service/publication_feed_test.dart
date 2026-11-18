import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flabr/core/component/http/http.dart';
import 'package:flabr/data/model/filter/filter.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flabr/data/service/publication_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FeedClient client;
  late PublicationService service;
  setUp(() {
    client = _FeedClient();
    service = PublicationServiceImpl(siteClient: client);
  });

  test('legacy feed settings keep the score and enable all formats', () {
    final filter = FeedFilter.fromJson({
      'score': {'value': '25', 'label': '+25'},
      'types': ['news'],
    });
    expect(filter.score.value, '25');
    expect(filter.criteria.formats, PublicationFormat.values);
  });

  test('personal feed filters round trip and posts open as articles', () async {
    const filter = FeedFilter(
      criteria: PublicationCriteria(
        complexity: .high,
        formats: [.post, .example],
      ),
    );
    final restored = FeedFilter.fromJson(jsonDecode(jsonEncode(filter)));
    final response = await service.fetchFeed(page: '2', filter: restored);
    expect(client.query, {
      'queryType': 'feed',
      'page': '2',
      'score': 'all',
      'complexity': 'hard',
      'formats[0]': 'post',
      'formats[1]': 'case',
    });
    final article = response.refs.single as PublicationCommon;
    expect(article.type, PublicationType.article);
    expect(article.format, PublicationFormat.post);
  });

  test(
    'all articles and thematic flows use distinct source selectors',
    () async {
      await service.fetchFlowArticles(
        flow: .all,
        filter: const FlowFilter(),
        page: '1',
      );
      expect(client.query, {
        'queryType': 'articles',
        'page': '1',
        'sort': 'rating',
      });
      await service.fetchFlowArticles(
        flow: .backend,
        filter: const FlowFilter(
          sort: .byBest,
          criteria: PublicationCriteria(complexity: .low, formats: [.common]),
        ),
        page: '3',
      );
      expect(client.query, {
        'queryType': 'flows_new',
        'flow': 'backend',
        'sort': 'all',
        'period': 'daily',
        'complexity': 'easy',
        'formats[0]': 'common',
        'page': '3',
      });
    },
  );
}

final class _FeedClient implements HttpClient {
  late Map<String, dynamic>? query;

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    expect(url, '/v2/articles/');
    query = queryParams;
    return Response(
      requestOptions: RequestOptions(path: url),
      data: {
        'pagesCount': 3,
        'publicationIds': ['123'],
        'publicationRefs': {
          '123': {'id': '123', 'publicationType': 'article', 'format': 'post'},
        },
      },
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
