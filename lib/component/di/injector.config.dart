// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_links/app_links.dart' as _i5;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/utils/utils.dart' as _i4;
import '../../feature/auth/repository/auth_repository.dart' as _i19;
import '../../feature/auth/repository/token_repository.dart' as _i9;
import '../../feature/auth/service/auth_service.dart' as _i12;
import '../../feature/company/repository/company_repository.dart' as _i22;
import '../../feature/company/service/company_service.dart' as _i17;
import '../../feature/hub/repository/hub_repository.dart' as _i23;
import '../../feature/hub/service/hub_service.dart' as _i16;
import '../../feature/publication/repository/publication_repository.dart'
    as _i18;
import '../../feature/publication/service/publication_service.dart' as _i14;
import '../../feature/search/repository/search_repository.dart' as _i25;
import '../../feature/search/service/search_service.dart' as _i20;
import '../../feature/settings/repository/language_repository.dart' as _i8;
import '../../feature/summary/repository/summary_repository.dart' as _i21;
import '../../feature/summary/repository/summary_token_repository.dart' as _i10;
import '../../feature/summary/service/summary_service.dart' as _i13;
import '../../feature/user/repository/user_repository.dart' as _i24;
import '../../feature/user/service/user_service.dart' as _i15;
import '../http/http_client.dart' as _i11;
import '../router/app_router.dart' as _i7;
import '../storage/cache_storage.dart' as _i6;
import 'module.dart' as _i26;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.dio);
  gh.singleton<_i4.Utils>(() => const _i4.Utils());
  gh.singleton<_i5.AppLinks>(() => registerModule.appLinks);
  gh.singleton<_i6.CacheStorage>(() => registerModule.secureStorage);
  gh.singleton<_i7.AppRouter>(() => _i7.AppRouter());
  gh.singleton<_i8.LanguageRepository>(
      () => _i8.LanguageRepository(storage: gh<_i6.CacheStorage>()));
  gh.singleton<_i9.TokenRepository>(
      () => _i9.TokenRepository(gh<_i6.CacheStorage>()));
  gh.singleton<_i10.SummaryTokenRepository>(
      () => _i10.SummaryTokenRepository(gh<_i6.CacheStorage>()));
  gh.singleton<_i11.HttpClient>(
    () => registerModule.summaryClient(
      gh<_i3.Dio>(),
      gh<_i10.SummaryTokenRepository>(),
    ),
    instanceName: 'ya300client',
  );
  gh.singleton<_i11.HttpClient>(
    () => registerModule.mobileClient(
      gh<_i3.Dio>(),
      gh<_i9.TokenRepository>(),
    ),
    instanceName: 'mobileClient',
  );
  gh.singleton<_i12.AuthService>(() => registerModule
      .authService(gh<_i11.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i13.SummaryService>(() => registerModule
      .summaryService(gh<_i11.HttpClient>(instanceName: 'ya300client')));
  gh.singleton<_i11.HttpClient>(
    () => registerModule.siteClient(gh<_i9.TokenRepository>()),
    instanceName: 'siteClient',
  );
  gh.lazySingleton<_i14.PublicationService>(
      () => registerModule.publicationService(
            gh<_i11.HttpClient>(instanceName: 'mobileClient'),
            gh<_i11.HttpClient>(instanceName: 'siteClient'),
          ));
  gh.lazySingleton<_i15.UserService>(() => registerModule.userService(
        gh<_i11.HttpClient>(instanceName: 'mobileClient'),
        gh<_i11.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i16.HubService>(() => registerModule.hubService(
        gh<_i11.HttpClient>(instanceName: 'mobileClient'),
        gh<_i11.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i17.CompanyService>(() => registerModule.companyService(
        gh<_i11.HttpClient>(instanceName: 'mobileClient'),
        gh<_i11.HttpClient>(instanceName: 'siteClient'),
      ));
  gh.lazySingleton<_i18.PublicationRepository>(
      () => _i18.PublicationRepository(gh<_i14.PublicationService>()));
  gh.singleton<_i19.AuthRepository>(
      () => _i19.AuthRepository(gh<_i12.AuthService>()));
  gh.lazySingleton<_i20.SearchService>(() => registerModule
      .searchService(gh<_i11.HttpClient>(instanceName: 'mobileClient')));
  gh.lazySingleton<_i21.SummaryRepository>(
      () => _i21.SummaryRepository(gh<_i13.SummaryService>()));
  gh.lazySingleton<_i22.CompanyRepository>(
      () => _i22.CompanyRepository(gh<_i17.CompanyService>()));
  gh.lazySingleton<_i23.HubRepository>(
      () => _i23.HubRepository(gh<_i16.HubService>()));
  gh.lazySingleton<_i24.UserRepository>(
      () => _i24.UserRepository(gh<_i15.UserService>()));
  gh.lazySingleton<_i25.SearchRepository>(
      () => _i25.SearchRepository(gh<_i20.SearchService>()));
  return getIt;
}

class _$RegisterModule extends _i26.RegisterModule {}
