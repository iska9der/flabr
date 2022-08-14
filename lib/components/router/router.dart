import 'package:auto_route/annotations.dart';
import 'package:flabr/pages/articles_page.dart';
import 'package:flabr/pages/news_page.dart';
import 'package:flabr/pages/settings_page.dart';

import '../../pages/wrapper_widget.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: WrapperPage,
      initial: true,
      children: [
        AutoRoute(path: 'articles', page: ArticlesPage),
        AutoRoute(path: 'news', page: NewsPage),
        AutoRoute(path: 'settings', page: SettingsPage),
      ],
    ),
  ],
)
// extend the generated private router
class $AppRouter {}
