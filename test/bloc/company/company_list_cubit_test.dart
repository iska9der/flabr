import 'package:flabr/bloc/company/company_list_cubit.dart';
import 'package:flabr/core/component/storage/storage.dart';
import 'package:flabr/data/model/company/company.dart';
import 'package:flabr/data/repository/repository.dart';
import 'package:flabr/presentation/page/settings/model/config_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MemoryStorage storage;
  late SettingsRepository settingsRepository;
  late CompanyListCubit cubit;

  setUp(() {
    storage = _MemoryStorage();
    settingsRepository = SettingsRepository(storage: storage);
    cubit = CompanyListCubit(
      repository: const _CompanyRepository(),
      settingsRepository: settingsRepository,
      languageRepository: LanguageRepository(storage: storage),
    );
  });

  tearDown(() => cubit.close());

  test('pagination replaces the current page', () async {
    settingsRepository.saveFeed(
      const FeedConfigModel(navigationMode: .pagination),
    );

    await _fetch(cubit);
    expect(
      cubit.state.response.refs.map((company) => company.alias),
      ['page-1'],
    );

    cubit.changePage(2);
    await _fetch(cubit);

    expect(cubit.state.currentPage, 2);
    expect(
      cubit.state.response.refs.map((company) => company.alias),
      ['page-2'],
    );
  });

  test('last-page boundary uses the fetched page', () {
    const beforeLastPage = CompanyListState(
      status: .success,
      page: 3,
      response: CompanyListResponse(pagesCount: 3),
    );
    const lastPage = CompanyListState(
      status: .success,
      page: 4,
      response: CompanyListResponse(pagesCount: 3),
    );

    expect(beforeLastPage.currentPage, 2);
    expect(beforeLastPage.isLastPage, isFalse);
    expect(lastPage.currentPage, 3);
    expect(lastPage.isLastPage, isTrue);
  });
}

Future<void> _fetch(CompanyListCubit cubit) async {
  final success = cubit.stream.firstWhere((state) => state.status == .success);
  cubit.fetch();
  await success;
}

class _CompanyRepository implements CompanyRepository {
  const _CompanyRepository();

  @override
  Future<CompanyListResponse> fetchAll({required int page}) async {
    final alias = 'page-$page';

    return CompanyListResponse(
      pagesCount: 3,
      ids: [alias],
      refs: [Company(alias: alias)],
    );
  }

  @override
  Future<CompanyCard> fetchCard(String alias) => throw UnimplementedError();
}

class _MemoryStorage implements CacheStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<void> deleteAll() async => _values.clear();

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}
