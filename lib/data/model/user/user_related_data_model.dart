import 'package:equatable/equatable.dart';

import '../related_data_base.dart';

class UserRelatedData extends RelatedDataBase with EquatableMixin {
  const UserRelatedData({this.isSubscribed = false});

  final bool isSubscribed;

  static const empty = UserRelatedData();
  bool get isEmpty => this == empty;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'isSubscribed': isSubscribed};
  }

  factory UserRelatedData.fromJson(Map<String, dynamic> map) {
    return UserRelatedData(
      isSubscribed: (map['isSubscribed'] ?? false) as bool,
    );
  }

  @override
  List<Object> get props => [isSubscribed];
}
