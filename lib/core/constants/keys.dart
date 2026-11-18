abstract class CacheKeys {
  static const themeConfig = 'theme_config';
  static const feedConfig = 'feed_config';
  static const publicationConfig = 'publication_config';
  static const miscConfig = 'misc_config';
  static const typographyConfig = 'typography_config';

  static const authTokens = 'aData';

  static const langUI = 'lang_ui';
  static const langPublications = 'lang_article';

  static const feedFilter = 'feed_filter';
  static const flowFilter = 'flow_filter_article';
}

abstract class Keys {
  static const csrfToken = 'csrf-token';
  static const sidToken = 'habr_web_sid';

  /// TODO: в 1.5.0 удалить ключ устаревшей cookie `connect_sid`
  static const legacySidToken = 'connect_sid';

  static const skipCsrf = 'X-Skip-Csrf';
  static const renewCsrf = 'X-Renew-Csrf';
}
