import 'dart:collection';

import '../list_response_model.dart';
import 'user_comment_model.dart';

class UserCommentListResponse extends ListResponse<UserComment> {
  UserCommentListResponse({super.pagesCount, super.ids, super.refs});

  factory UserCommentListResponse.fromMap(Map<String, dynamic> map) {
    final commentsMap = Map<String, dynamic>.from(map['comments'] ?? {});

    return UserCommentListResponse(
      pagesCount: map['pages'] ?? 0,
      refs: UnmodifiableListView(
        commentsMap.entries.map((e) => UserComment.fromMap(e.value)),
      ),
    );
  }
}
