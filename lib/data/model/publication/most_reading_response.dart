import 'package:equatable/equatable.dart';

import '../list_response_model.dart';
import 'publication_model.dart';

class MostReadingResponse extends ListResponse<PublicationCommon>
    with EquatableMixin {
  const MostReadingResponse({
    super.pagesCount = 1,
    super.ids = const [],
    super.refs = const [],
  });

  factory MostReadingResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['articleIds'] ?? map['newsIds'];
    Map refsMap = map['articleRefs'] ?? map['newsRefs'];

    return MostReadingResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs:
          Map.from(
            refsMap,
          ).entries.map((e) => PublicationCommon.fromMap(e.value)).toList(),
    );
  }

  static const empty = MostReadingResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
