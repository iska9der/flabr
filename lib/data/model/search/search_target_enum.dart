import '../../../i18n/i18n.dart';

enum SearchTarget {
  posts,
  hubs,
  companies,
  users,
  comments;

  String get label => switch (this) {
    SearchTarget.posts => t.search.targetArticles,
    SearchTarget.hubs => t.search.targetHubs,
    SearchTarget.companies => t.search.targetCompanies,
    SearchTarget.users => t.search.targetUsers,
    SearchTarget.comments => t.search.targetComments,
  };
}
