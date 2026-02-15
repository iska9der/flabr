part of 'router.dart';

class SplashGuard extends AutoRouteGuard {
  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final repository = getIt<AppConfigRepository>();

    if (repository.isInitialized) {
      resolver.next();
      return;
    }

    // Показываем Splash поверх всего
    router.push(const SplashRoute());

    await repository.onInitialized.firstWhere((v) => v);

    // Убираем Splash
    router.removeLast();

    resolver.next();
  }
}
