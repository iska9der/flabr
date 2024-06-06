part of 'part.dart';

abstract class CacheKey {
  static const themeConfig = 'theme_config';
  static const feedConfig = 'feed_config';
  static const publicationConfig = 'publication_config';
  static const miscConfig = 'misc_config';

  static const authData = 'aData';
  static const authCsrf = 'cData';

  static const langUI = 'lang_ui';
  static const langArticle = 'lang_article';

  static const feedFilter = 'feed_filter';
  static flowFilter(String section) => 'flow_filter_$section';
}
