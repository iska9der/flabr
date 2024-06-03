import 'package:equatable/equatable.dart';

import '../../../../data/model/network/list_response.dart';
import '../hub_model.dart';

class HubListResponse extends ListResponse with EquatableMixin {
  const HubListResponse({
    super.pagesCount = 1,
    super.ids = const [],
    List<HubModel> super.refs = const [],
  });

  @override
  List<HubModel> get refs => super.refs as List<HubModel>;

  @override
  HubListResponse copyWith({
    int? pagesCount,
    List<String>? ids,
    List<dynamic>? refs,
  }) {
    return HubListResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      ids: ids ?? this.ids,
      refs: List<HubModel>.from((refs ?? this.refs)),
    );
  }

  factory HubListResponse.fromMap(Map<String, dynamic> map) {
    var idsMap = map['hubIds'];
    Map refsMap = map['hubRefs'];

    return HubListResponse(
      pagesCount: map['pagesCount'] ?? 1,
      ids: List<String>.from(idsMap),
      refs: Map.from(refsMap)
          .entries
          .map((e) => HubModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = HubListResponse(pagesCount: 0);
  get isEmpty => this == empty;

  @override
  List<Object?> get props => [pagesCount, ids, refs];
}
