import 'package:equatable/equatable.dart';

import '../publication/publication.dart';
import 'list_response_model.dart';

class MostReadingResponse extends ListResponse with EquatableMixin {
  const MostReadingResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<PublicationCommon> super.refs = const [],
  });

  @override
  List<PublicationCommon> get refs => super.refs as List<PublicationCommon>;

  @override
  MostReadingResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return MostReadingResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<PublicationCommon>.from((refs ?? this.refs)),
    );
  }

  factory MostReadingResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['articleIds'] ?? map['newsIds'];
    Map refsMap = map['articleRefs'] ?? map['newsRefs'];

    return MostReadingResponse(
      pagesCount: map['pagesCount'] ?? 0,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => PublicationCommon.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = MostReadingResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object> get props => [pagesCount, ids, refs];
}
