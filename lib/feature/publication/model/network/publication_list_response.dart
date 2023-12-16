import 'package:equatable/equatable.dart';

import '../../../../common/model/network/list_response.dart';
import '../common_model.dart';

class PublicationListResponse extends ListResponse with EquatableMixin {
  const PublicationListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<CommonModel> super.refs = const [],
  });

  @override
  List<CommonModel> get refs => super.refs as List<CommonModel>;

  @override
  PublicationListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return PublicationListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<CommonModel>.from((refs ?? this.refs)),
    );
  }

  factory PublicationListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['publicationIds'];
    Map refsMap = map['publicationRefs'];

    return PublicationListResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => CommonModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = PublicationListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
