import 'package:equatable/equatable.dart';

import 'article_lead_data.dart';
import 'article_statistics.dart';

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    this.titleHtml = '',
    this.textHtml = '',
    this.timePublished = '',
    this.leadData = ArticleLeadData.empty,
    this.statistics = ArticleStatistics.empty,
  });

  final String id;

  /// Заголовок
  final String titleHtml;

  /// Полный текст статьи
  final String textHtml;
  final String timePublished;
  final ArticleLeadData leadData;
  final ArticleStatistics statistics;

  DateTime get publishedAt => DateTime.parse(timePublished);

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] as String,
      titleHtml: map['titleHtml'] as String,
      textHtml: map['textHtml'] ?? '',
      timePublished: map['timePublished'],
      leadData: ArticleLeadData.fromMap(map['leadData']),
      statistics: ArticleStatistics.fromMap(map['statistics']),
    );
  }

  static const empty = ArticleModel(id: '0');

  @override
  List<Object> get props => [
        id,
        titleHtml,
        textHtml,
        timePublished,
        leadData,
        statistics,
      ];
}
