import '../../hub/model/hub_model.dart';
import 'article_hub_type.dart';

class ArticleHubModel extends HubModel {
  const ArticleHubModel({
    required super.alias,
    required super.isProfiled,
    super.relatedData,
    required this.id,
    required this.title,
    required this.type,
  });

  final String id;
  final String title;
  final ArticleHubType type;

  factory ArticleHubModel.fromMap(Map<String, dynamic> map) {
    return ArticleHubModel(
      alias: map['alias'] as String,
      isProfiled: map['isProfiled'] as bool,
      relatedData: map['relatedData'] ?? const {},
      id: map['id'],
      title: map['title'] as String,
      type: ArticleHubType.fromString(map['type']),
    );
  }

  @override
  List<Object> get props => [
        ...super.props,
        id,
        title,
        type,
      ];
}
