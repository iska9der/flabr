import '../user/user_comment_model.dart';
import 'list_response_model.dart';

class UserCommentListResponse extends ListResponse {
  UserCommentListResponse({super.pagesCount, super.ids, super.refs});

  @override
  List<UserComment> get refs => super.refs as List<UserComment>;

  factory UserCommentListResponse.fromMap(Map<String, dynamic> map) {
    return UserCommentListResponse(
      pagesCount: map['pages'] ?? 0,
      refs: Map.from(map['comments'] as Map)
          .entries
          .map((e) => UserComment.fromMap(e.value))
          .toList(),
    );
  }
}
