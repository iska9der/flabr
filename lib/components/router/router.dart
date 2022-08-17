import 'package:auto_route/annotations.dart';

import '../../page/articles_page.dart';
import '../../page/news_page.dart';
import '../../page/settings_page.dart';
import '../../page/wrapper_widget.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: WrapperPage,
      initial: true,
      children: [
        AutoRoute(path: 'article', page: ArticlesPage),
        AutoRoute(path: 'news', page: NewsPage),
        AutoRoute(path: 'settings', page: SettingsPage),
      ],
    ),
  ],
)
// extend the generated private router
class $AppRouter {}
