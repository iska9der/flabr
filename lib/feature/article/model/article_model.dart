import 'package:equatable/equatable.dart';

import '../../../common/model/author_model.dart';
import 'article_lead_data_model.dart';
import 'article_statistics_model.dart';

class ArticleModel extends Equatable {
  const ArticleModel({
    required this.id,
    this.timePublished = '',
    this.titleHtml = '',
    this.textHtml = '',
    this.author = AuthorModel.empty,
    this.statistics = ArticleStatisticsModel.empty,
    this.leadData = ArticleLeadDataModel.empty,
  });

  final String id;
  final String timePublished;

  /// Заголовок
  final String titleHtml;

  /// Полный текст статьи
  /// прилетает, только если получаем конкретную статью по id
  final String textHtml;
  final AuthorModel author;
  final ArticleStatisticsModel statistics;
  final ArticleLeadDataModel leadData;

  DateTime get publishedAt => DateTime.parse(timePublished);

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'],
      timePublished: map['timePublished'],
      titleHtml: map['titleHtml'],
      textHtml: map['textHtml'] ?? '',
      author: map['author'] != null
          ? AuthorModel.fromMap(map['author'])
          : AuthorModel.empty,
      statistics: map['statistics'] != null
          ? ArticleStatisticsModel.fromMap(map['statistics'])
          : ArticleStatisticsModel.empty,
      leadData: map['leadData'] != null
          ? ArticleLeadDataModel.fromMap(map['leadData'])
          : ArticleLeadDataModel.empty,
    );
  }

  static const empty = ArticleModel(id: '0');
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [
        id,
        timePublished,
        titleHtml,
        textHtml,
        author,
        statistics,
        leadData,
      ];
}
