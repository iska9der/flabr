part of 'router.dart';

extension UrlLauncherExtension on AppRouter {
  /// Открыть внешнюю ссылку во внешнем приложении
  Future<bool> launchUrl(String url) =>
      launchUrlString(url, mode: LaunchMode.externalApplication);

  /// Открыть ссылку в приложении, либо в браузере
  Future<dynamic> navigateOrLaunchUrl(Uri uri) async {
    final id = _parseId(uri);
    if (id != null) {
      final type = _parsePublicationType(uri);
      if (type != null) {
        final commentId = _parseCommentFragmentId(uri.fragment);
        return await push(
          PublicationFlowRoute(
            type: type.name,
            id: id,
            children: [
              PublicationDetailRoute(),
              if (commentId != null)
                PublicationCommentsRoute(initialId: commentId),
            ],
          ),
        );
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

    return await launchUrl(uri.toString());
  }

  String? _parseId(Uri url) {
    final parts = url.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return null;
    }

    if (parts.length > 1 && parts.last == 'comments') {
      return parts[parts.length - 2];
    }

    return parts.last;
  }

  static final Map<PublicationType, Set<String>> _publicationMatcher = {
    .article: {'article/', 'articles/', 'post/', 'blog/', 'blogs/'},
    .post: {'posts/'},
    .news: {'news/'},
  };

  PublicationType? _parsePublicationType(Uri uri) {
    if (!AppEnvironment.isHostSafe(uri)) {
      return null;
    }

    for (final entry in _publicationMatcher.entries) {
      final isMatch = entry.value.any((v) => uri.path.contains(v));
      if (isMatch) {
        return entry.key;
      }
    }

    return null;
  }

  bool isUserUrl(Uri uri) {
    if (AppEnvironment.isHostSafe(uri) && uri.path.contains('users/')) {
      return true;
    }

    if (uri.host.isEmpty && uri.path.contains('/users/')) {
      return true;
    }

    return false;
  }
}
