enum SearchTarget { posts, hubs, companies, users, comments }

extension SearchTargetX on SearchTarget {
  String get label => switch (this) {
        SearchTarget.posts => 'Статьи',
        SearchTarget.hubs => 'Хабы',
        SearchTarget.companies => 'Компании',
        SearchTarget.users => 'Пользователи',
        SearchTarget.comments => 'Комментарии'
      };
}
