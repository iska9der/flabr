import 'package:equatable/equatable.dart';

import '../hub_type_enum.dart';

class CompanyHubModel extends Equatable {
  const CompanyHubModel({
    required this.alias,
    this.title = '',
    this.type = HubType.collective,
    this.isProfiled = false,
  });

  final String alias;
  final String title;
  final HubType type;
  final bool isProfiled;

  factory CompanyHubModel.fromMap(Map<String, dynamic> map) {
    return CompanyHubModel(
      alias: (map['alias'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      type: HubType.fromString((map['type'] ?? 'collective')),
      isProfiled: (map['isProfiled'] ?? false) as bool,
    );
  }

  @override
  List<Object> get props => [alias, title, type, isProfiled];
}
