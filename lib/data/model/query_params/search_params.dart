import '../../exception/part.dart';
import '../search/search_target_enum.dart';
import 'params_model.dart';
import 'search_article_params.dart';
import 'search_company_params.dart';
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
    return switch (target) {
      SearchTarget.posts => SearchArticleParams(
          query: query,
          order: order,
          langArticles: langArticles,
          langUI: langUI,
          page: page.toString(),
        ),
      SearchTarget.hubs => SearchHubParams(
          query: query,
          order: order,
          langArticles: langArticles,
          langUI: langUI,
          page: page.toString(),
        ),
      SearchTarget.companies => SearchCompanyParams(
          query: query,
          order: order,
          langArticles: langArticles,
          langUI: langUI,
          page: page.toString(),
        ),
      SearchTarget.users => SearchUserParams(
          query: query,
          order: order,
          langArticles: langArticles,
          langUI: langUI,
          page: page.toString(),
        ),
      SearchTarget.comments => throw ValueException('Не реализовано'),
    };
  }
}
