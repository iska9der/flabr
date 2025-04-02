part of 'app_router.dart';

extension UrlLauncherX on AppRouter {
  /// Открыть внешнюю ссылку во внешнем приложении
  Future<bool> launchUrl(String url) =>
      launchUrlString(url, mode: LaunchMode.externalApplication);

  /// Открыть ссылку в приложении, либо в браузере
  Future<dynamic> navigateOrLaunchUrl(Uri uri) async {
    final id = _parseId(uri);

    if (id == null) {
      return await launchUrl(uri.toString());
    }

    final type = _publicationTypeHandler(uri);
    if (type != null) {
      return await pushWidget(PublicationDetailPage(id: id, type: type.name));
    }

    final isUser = isUserUrl(uri);
    if (isUser) {
      return await navigate(
        ServicesFlowRoute(
          children: [
            UserDashboardRoute(alias: id, children: [UserDetailRoute()]),
          ],
        ),
      );
    }
  }

  String? _parseId(Uri url) {
    Iterable<String> parts = url.pathSegments.where(
      (element) => element.isNotEmpty,
    );

    if (parts.isEmpty) {
      return null;
    }

    return parts.last;
  }

  bool _isHostCompatible(Uri uri) =>
      uri.host.contains('habr.com') || uri.host.contains('habrahabr.ru');

  static final Map<PublicationType, Set<String>> _publicationMatcher = {
    PublicationType.article: {'article/', 'articles/', 'blog/', 'blogs/'},
    PublicationType.post: {'posts/'},
    PublicationType.news: {'news/'},
  };

  PublicationType? _publicationTypeHandler(Uri uri) {
    if (!_isHostCompatible(uri)) {
      return null;
    }

    for (final entry in _publicationMatcher.entries) {
      final isMatch = entry.value.any(
        (comparePath) => uri.path.contains(comparePath),
      );

      if (isMatch) {
        return entry.key;
      }
    }

    return null;
  }

  bool isUserUrl(Uri uri) {
    if (_isHostCompatible(uri) && uri.path.contains('users/')) {
      return true;
    }

    if (uri.host.isEmpty && uri.path.contains('/users/')) {
      return true;
    }

    return false;
  }
}
