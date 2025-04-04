import '../../exception/exception.dart';
import '../query_params_model.dart';
import 'search_article_params.dart';
import 'search_company_params.dart';
import 'search_hub_params.dart';
import 'search_target_enum.dart';
import 'search_user_params.dart';

abstract class SearchParamsFactory extends QueryParams {
  factory SearchParamsFactory.from({
    required String langUI,
    required String langArticles,
    required String query,
    required SearchTarget target,
    required String order,
    required int page,
  }) => switch (target) {
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
    SearchTarget.comments => throw const ValueException('Не реализовано'),
  };
}
