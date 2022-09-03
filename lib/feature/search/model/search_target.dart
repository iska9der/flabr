enum SearchTarget { posts, hubs, companies, users, comments }

extension SearchTargetX on SearchTarget {
  String get label {
    switch (this) {
      case SearchTarget.posts:
        return 'Статьи';

      case SearchTarget.hubs:
        return 'Хабы';

      case SearchTarget.companies:
        return 'Компании';

      case SearchTarget.users:
        return 'Пользователи';

      case SearchTarget.comments:
        return 'Комментарии';
    }
  }
}
