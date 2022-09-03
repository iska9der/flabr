import '../../../../common/exception/value_exception.dart';
import '../../../../common/model/network/params.dart';
import '../search_target.dart';
import 'search_article_params.dart';
import 'search_hub_params.dart';
import 'search_user_params.dart';

abstract class SearchParamsFactory extends Params {
  factory SearchParamsFactory.from({
    required String langUI,
    required String langArticles,
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  }) {
    switch (target) {
      case SearchTarget.posts:
        return SearchArticleParams(
          query: query,
          order: order,
          hl: langUI,
          fl: langArticles,
          page: page.toString(),
        );
      case SearchTarget.hubs:
        return SearchHubParams(
          query: query,
          order: order,
          hl: langUI,
          fl: langArticles,
          page: page.toString(),
        );
      case SearchTarget.companies:
        throw ValueException('Не реализовано');
      case SearchTarget.users:
        return SearchUserParams(
          query: query,
          order: order,
          hl: langUI,
          fl: langArticles,
          page: page.toString(),
        );
      case SearchTarget.comments:
        throw ValueException('Не реализовано');
    }
  }
}
