import '../../../../common/model/network/list_response.dart';
import '../user_comment_model.dart';

class UserCommentListResponse extends ListResponse {
  UserCommentListResponse({super.pagesCount, super.ids, super.refs});

  @override
  List<UserCommentModel> get refs => super.refs as List<UserCommentModel>;

  factory UserCommentListResponse.fromMap(Map<String, dynamic> map) {
    return UserCommentListResponse(
      pagesCount: map['pages'] ?? 0,
      refs: Map.from(map['comments'] as Map)
          .entries
          .map((e) => UserCommentModel.fromMap(e.value))
          .toList(),
    );
  }
}
