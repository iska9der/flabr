import 'package:equatable/equatable.dart';

import 'article_author_model.dart';
import 'article_hub_model.dart';
import 'article_lead_data_model.dart';
import 'article_statistics_model.dart';
import 'article_type.dart';

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    this.type = ArticleType.article,
    this.timePublished = '',
    this.titleHtml = '',
    this.textHtml = '',
    this.author = ArticleAuthorModel.empty,
    this.statistics = ArticleStatisticsModel.empty,
    this.leadData = ArticleLeadDataModel.empty,
    this.hubs = const [],
  });

  final String id;
  final ArticleType type;

  final String timePublished;
  DateTime get publishedAt => DateTime.parse(timePublished).toLocal();

  /// Заголовок
  final String titleHtml;

  /// Полный текст статьи
  /// прилетает, только если получаем конкретную статью по id
  final String textHtml;
  final ArticleAuthorModel author;
  final ArticleStatisticsModel statistics;
  final ArticleLeadDataModel leadData;
  final List<ArticleHubModel> hubs;

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'],
      type: map['postType'] != null
          ? ArticleType.fromString(map['postType'])
          : ArticleType.article,
      timePublished: map['timePublished'],
      titleHtml: map['titleHtml'],
      textHtml: map['textHtml'] ?? '',
      author: map['author'] != null
          ? ArticleAuthorModel.fromMap(map['author'])
          : ArticleAuthorModel.empty,
      statistics: map['statistics'] != null
          ? ArticleStatisticsModel.fromMap(map['statistics'])
          : ArticleStatisticsModel.empty,
      leadData: map['leadData'] != null
          ? ArticleLeadDataModel.fromMap(map['leadData'])
          : ArticleLeadDataModel.empty,
      hubs: map['hubs'] != null
          ? List<ArticleHubModel>.from(
              map['hubs'].map((e) => ArticleHubModel.fromMap(e)),
            ).toList()
          : const [],
    );
  }

  static const empty = ArticleModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        id,
        type,
        timePublished,
        titleHtml,
        textHtml,
        author,
        statistics,
        leadData,
        hubs,
      ];
}
