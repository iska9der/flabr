abstract class CacheKeys {
  static const themeConfig = 'theme_config';
  static const feedConfig = 'feed_config';
  static const publicationConfig = 'publication_config';
  static const miscConfig = 'misc_config';

  static const authTokens = 'aData';

  static const langUI = 'lang_ui';
  static const langPublications = 'lang_article';

  static const feedFilter = 'feed_filter';
  static String flowFilter(String section) => 'flow_filter_$section';
}

abstract class Keys {
  static const renewCsrf = 'renew-csrf';
}
