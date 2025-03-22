import '../list_response_model.dart';
import 'user_comment_model.dart';

class UserCommentListResponse extends ListResponse<UserComment> {
  UserCommentListResponse({super.pagesCount, super.ids, super.refs});

  factory UserCommentListResponse.fromMap(Map<String, dynamic> map) {
    return UserCommentListResponse(
      pagesCount: map['pages'] ?? 0,
      refs:
          Map.from(
            map['comments'] as Map,
          ).entries.map((e) => UserComment.fromMap(e.value)).toList(),
    );
  }
}
