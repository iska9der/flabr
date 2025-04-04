import 'dart:async';

import 'package:injectable/injectable.dart';

import '../model/language/language.dart';
import '../model/list_response_model.dart';
import '../model/user/user.dart';
import '../service/service.dart';

@LazySingleton()
class UserRepository {
  UserRepository(UserService service) : _service = service;

  final UserService _service;

  ListResponse<User> cached = UserListResponse.empty;

  Future<UserListResponse> fetchAll({
    required Language langUI,
    required List<Language> langArticles,
    required String page,
  }) async {
    final response = await _service.fetchAll(
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
      page: page,
    );

    cached = cached.copyWith(
      pagesCount: response.pagesCount,
      ids: [...cached.ids, ...response.ids],
      refs: [...cached.refs, ...response.refs],
    );

    return response;
  }

  Future<User> fetchCard({
    required String login,
    required Language langUI,
    required List<Language> langArticles,
  }) async {
    final raw = await _service.fetchCard(
      alias: login,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    User model = User.fromMap(raw);

    return model;
  }

  Future<UserWhois> fetchWhois({
    required String login,
    required Language langUI,
    required List<Language> langArticles,
  }) async {
    final raw = await _service.fetchWhois(
      alias: login,
      langUI: langUI.name,
      langArticles: LanguageEncoder.encodeLangs(langArticles),
    );

    UserWhois model = UserWhois.fromMap(raw);

    return model;
  }

  Future<ListResponse<UserComment>> fetchComments({
    required String alias,
    required int page,
  }) async {
    var response = await _service.fetchComments(alias: alias, page: page);

    final sortedList = [...response.refs]
      ..sort((a, b) => b.timePublished.compareTo(a.timePublished));
    response = response.copyWith(refs: sortedList);

    return response;
  }

  Future<UserCommentListResponse> fetchCommentsInBookmarks({
    required String alias,
    int page = 1,
  }) => _service.fetchCommentsInBookmarks(alias: alias, page: page);
}
