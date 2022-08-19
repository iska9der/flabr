import 'package:equatable/equatable.dart';
import 'package:flabr/feature/article/model/article_statistics.dart';

import 'article_lead_data.dart';

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    required this.titleHtml,
    required this.timePublished,
    required this.leadData,
    required this.statistics,
  });

  final String id;
  final String titleHtml;
  final DateTime timePublished;
  final ArticleLeadData leadData;
  final ArticleStatistics statistics;

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] as String,
      titleHtml: map['titleHtml'] as String,
      timePublished: DateTime.parse(map['timePublished']),
      leadData: ArticleLeadData.fromMap(map['leadData']),
      statistics: ArticleStatistics.fromMap(map['statistics']),
    );
  }

  @override
  List<Object> get props => [
        id,
        titleHtml,
        timePublished,
        leadData,
        statistics,
      ];
}
