import '../../../../common/model/network/list_response.dart';
import '../../../publication/model/comment/comment_model.dart';

class UserCommentListResponse extends ListResponse {
  UserCommentListResponse({super.pagesCount, super.ids, super.refs});

  @override
  List<CommentModel> get refs => super.refs as List<CommentModel>;

  factory UserCommentListResponse.fromMap(Map<String, dynamic> map) {
    return UserCommentListResponse(
      pagesCount: map['pages'] ?? 0,
      refs: Map.from(map['comments'] as Map)
          .entries
          .map((e) => CommentModel.fromMap(e.value))
          .toList(),
    );
  }
}
