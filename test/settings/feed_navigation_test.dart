import 'dart:convert';

import 'package:flabr/core/component/storage/cache_storage.dart';
import 'package:flabr/core/constants/constants.dart';
import 'package:flabr/data/model/list_response_model.dart';
import 'package:flabr/data/model/loading_status_enum.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flabr/data/repository/language_repository.dart';
import 'package:flabr/data/repository/publication_repository.dart';
import 'package:flabr/data/repository/settings_repository.dart';
import 'package:flabr/data/service/publication_service.dart';
import 'package:flabr/feature/publication_list/publication_list.dart';
import 'package:flabr/presentation/page/settings/model/config_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feed navigation setting', () {
    test('defaults to infinite scroll for an existing stored config', () {
      final config = FeedConfigModel.fromJson({
        'isImageVisible': false,
        'isDescriptionVisible': true,
      });

      expect(config.navigationMode, FeedNavigationMode.infiniteScroll);
    });

    test('persists pagination mode', () {
      const config = FeedConfigModel(
        navigationMode: FeedNavigationMode.pagination,
      );

      final restored = FeedConfigModel.fromJson(config.toJson());

      expect(restored.navigationMode, FeedNavigationMode.pagination);
    });

    test('publishes the complete restored and saved config', () async {
      const pagination = FeedConfigModel(
        navigationMode: FeedNavigationMode.pagination,
      );
      final storage = _MemoryCacheStorage();
      await storage.write(
        CacheKeys.feedConfig,
        jsonEncode(pagination.toJson()),
      );
      final repository = SettingsRepository(storage: storage);

      final restored = await repository.initConfig();

      expect(repository.lastConfig, restored);
      await expectLater(repository.onChange, emits(restored));

      const infiniteScroll = FeedConfigModel();
      final expected = restored.copyWith(feed: infiniteScroll);
      repository.saveFeed(infiniteScroll);

      expect(repository.lastConfig, expected);
      await expectLater(repository.onChange, emits(expected));
    });
  });

  group('Publication page state', () {
    test('uses the requested page while it is loading', () {
      const state = _TestPublicationListState(
        status: LoadingStatus.loading,
        page: 3,
      );

      expect(state.currentPage, 3);
    });

    test('exposes the fetched page for refresh', () {
      const state = _TestPublicationListState(
        status: LoadingStatus.success,
        page: 4,
        response: ListResponse<Publication>(pagesCount: 3),
      );

      expect(state.currentPage, 3);
      expect(state.isLastPage, isTrue);
    });

    test('refresh reads the latest navigation mode from repository', () async {
      final storage = _MemoryCacheStorage();
      final settingsRepository = SettingsRepository(storage: storage);
      final cubit = _TestPublicationListCubit(
        repository: PublicationRepository(
          _NoOpPublicationService(),
          storage: storage,
        ),
        languageRepository: LanguageRepository(storage: storage),
        settingsRepository: settingsRepository,
      );

      cubit.setLoadedPage(2);
      cubit.refresh();
      expect(cubit.state.page, 1);

      settingsRepository.saveFeed(
        const FeedConfigModel(
          navigationMode: FeedNavigationMode.pagination,
        ),
      );

      cubit.setLoadedPage(2);
      cubit.refresh();
      expect(cubit.state.page, 2);

      await cubit.close();
    });

    test('restoring pagination does not reset or refetch the cubit', () async {
      const pagination = FeedConfigModel(
        navigationMode: FeedNavigationMode.pagination,
      );
      final storage = _MemoryCacheStorage();
      await storage.write(
        CacheKeys.feedConfig,
        jsonEncode(pagination.toJson()),
      );
      final settingsRepository = SettingsRepository(storage: storage);
      final cubit = _TestPublicationListCubit(
        repository: PublicationRepository(
          _NoOpPublicationService(),
          storage: storage,
        ),
        languageRepository: LanguageRepository(storage: storage),
        settingsRepository: settingsRepository,
      );

      cubit.fetch();
      expect(cubit.fetchCount, 1);
      expect(cubit.state.status, LoadingStatus.success);
      expect(cubit.state.currentPage, 1);

      await settingsRepository.initConfig();
      await Future<void>.delayed(Duration.zero);

      expect(
        settingsRepository.lastConfig.feed.navigationMode,
        FeedNavigationMode.pagination,
      );
      expect(cubit.fetchCount, 1);
      expect(cubit.state.status, LoadingStatus.success);
      expect(cubit.state.currentPage, 1);

      await cubit.close();
    });
  });
}

class _TestPublicationListState extends PublicationListState {
  const _TestPublicationListState({
    required super.status,
    required super.page,
    super.error = '',
    super.response = const ListResponse<Publication>(),
  });
}

class _TestPublicationListCubit
    extends PublicationListCubit<_TestPublicationListState> {
  _TestPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    required super.settingsRepository,
  }) : super(
         const _TestPublicationListState(
           status: LoadingStatus.initial,
           page: 1,
         ),
       );

  // ignore: avoid-bloc-public-fields
  int fetchCount = 0;

  void setLoadedPage(int page) {
    emit(
      _TestPublicationListState(
        status: LoadingStatus.success,
        page: page + 1,
        response: const ListResponse<Publication>(pagesCount: 10),
      ),
    );
  }

  @override
  void emitInitialState({int page = 1}) {
    emit(
      _TestPublicationListState(
        status: LoadingStatus.initial,
        page: page,
      ),
    );
  }

  @override
  void fetch() {
    fetchCount++;
    emit(
      _TestPublicationListState(
        status: LoadingStatus.success,
        page: state.page + 1,
        response: const ListResponse<Publication>(pagesCount: 10),
      ),
    );
  }
}

final class _NoOpPublicationService implements PublicationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MemoryCacheStorage implements CacheStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }
}
