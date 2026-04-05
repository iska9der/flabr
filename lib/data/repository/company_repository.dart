import 'package:injectable/injectable.dart';

import '../model/company/company.dart';
import '../service/service.dart';

abstract interface class CompanyRepository {
  Future<CompanyListResponse> fetchAll({required int page});

  Future<CompanyCard> fetchCard(String alias);
}

@prod
@dev
@LazySingleton(as: CompanyRepository)
class CompanyRepositoryApi implements CompanyRepository {
  const CompanyRepositoryApi(CompanyService service) : _service = service;

  final CompanyService _service;

  @override
  Future<CompanyListResponse> fetchAll({required int page}) async {
    final response = await _service.fetchAll(page: page);

    return response;
  }

  @override
  Future<CompanyCard> fetchCard(String alias) async {
    final raw = await _service.fetchCard(alias);

    final model = CompanyCard.fromMap(raw);

    return model;
  }
}

@test
@LazySingleton(as: CompanyRepository)
class CompanyRepositoryTest implements CompanyRepository {
  const CompanyRepositoryTest();

  static const delay = Duration(milliseconds: 400);

  @override
  Future<CompanyListResponse> fetchAll({required int page}) async {
    await Future.delayed(delay);

    final CompanyListResponse duplicate = const .new(
      pagesCount: 3,
      ids: ['aboba', 'agugashka', 'dadida', 'larualump222', 'jpchermander'],
      refs: [
        .new(
          alias: 'aboba',
          titleHtml: 'Aboba Inc.',
          descriptionHtml:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris.',
          statistics: CompanyStatistics(subscribersCount: 45, rating: 100),
        ),
        .new(
          alias: 'agugashka',
          titleHtml: 'Aguga Inc.',
          descriptionHtml:
              '<i>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</i>',
          statistics: CompanyStatistics(subscribersCount: 22, rating: 46),
        ),
        .new(
          alias: 'dadida',
          titleHtml: 'Dadida Inc.',
          commonHubs: [.new(alias: 'flutter', title: 'Flutter')],
        ),
        .new(
          alias: 'larualump222',
          titleHtml: 'Larua Lumpen Inc.',
          descriptionHtml:
              'Sed sit amet ipsum mauris. Vivamus hendrerit arcu sed erat molestie vehicula. Sed auctor neque eu tellus rhoncus ut eleifend nibh porttitor.',
        ),
        .new(alias: 'jpchermander', titleHtml: 'JP Chermander Inc.'),
      ],
    );

    final response = duplicate;

    return response;
  }

  @override
  Future<CompanyCard> fetchCard(String alias) async {
    await Future.delayed(delay);

    final CompanyCard model = const .new(
      alias: 'agugashka',
      titleHtml: 'Aguga Inc.',
    );

    return model;
  }
}
