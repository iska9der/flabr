import 'package:dio/dio.dart';
import 'package:flabr/core/component/http/http.dart';
import 'package:flabr/data/model/company/company.dart';
import 'package:flabr/data/model/hub/hub.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flabr/data/model/search/search.dart';
import 'package:flabr/data/model/user/user.dart';
import 'package:flabr/data/service/service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('service parses a raw company card response', () async {
    const client = _StubHttpClient({'alias': 'acme'});
    const service = CompanyServiceImpl(
      siteClient: client,
    );

    final company = await service.fetchCard('acme');

    expect(company, isA<CompanyCard>());
    expect(company.alias, 'acme');
  });

  test('service does not mask parsing errors as FetchException', () async {
    const client = _StubHttpClient({'alias': 1});
    const service = CompanyServiceImpl(
      siteClient: client,
    );

    await expectLater(service.fetchCard('acme'), throwsA(isA<TypeError>()));
  });

  group('SearchService parses responses by target', () {
    final cases = <SearchTarget, Matcher>{
      SearchTarget.posts: isA<PublicationCommonListResponse>(),
      SearchTarget.hubs: isA<HubListResponse>(),
      SearchTarget.companies: isA<CompanyListResponse>(),
      SearchTarget.users: isA<UserListResponse>(),
    };

    for (final entry in cases.entries) {
      test(entry.key.name, () async {
        const service = SearchServiceImpl(
          _StubHttpClient(<String, dynamic>{}),
        );

        final response = await service.fetch(
          query: 'flutter',
          target: entry.key,
          order: SearchOrder.relevance.name,
          page: 1,
        );

        expect(response, entry.value);
      });
    }
  });
}

final class _StubHttpClient implements HttpClient {
  const _StubHttpClient(this.data);

  final Object? data;

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async => Response(
    data: data,
    requestOptions: RequestOptions(path: url),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
