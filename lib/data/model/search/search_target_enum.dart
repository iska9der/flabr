import '../../../i18n/i18n.dart';

enum SearchTarget {
  posts,
  hubs,
  companies,
  users,
  comments;

  String get label => switch (this) {
    SearchTarget.posts => t.search.target.articles,
    SearchTarget.hubs => t.search.target.hubs,
    SearchTarget.companies => t.search.target.companies,
    SearchTarget.users => t.search.target.users,
    SearchTarget.comments => t.search.target.comments,
  };
}
