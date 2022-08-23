import 'package:equatable/equatable.dart';

import '../article_model.dart';

class ArticlesResponse extends Equatable {
  const ArticlesResponse({
    required this.pagesCount,
    required this.articleIds,
    required this.models,
  });

  final int pagesCount;
  final List<String> articleIds;
  final List<ArticleModel> models;

  ArticlesResponse copyWith({
    int? pagesCount,
    List<String>? articleIds,
    List<ArticleModel>? models,
  }) {
    return ArticlesResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      articleIds: articleIds ?? this.articleIds,
      models: models ?? this.models,
    );
  }

  factory ArticlesResponse.fromMap(Map<String, dynamic> map) {
    return ArticlesResponse(
      pagesCount: map['pagesCount'] ?? 0,
      articleIds: List<String>.from((map['articleIds'])),
      models: Map.from((map['articleRefs'] as Map))
          .entries

          /// только статьи, новости откидываем
          .where((e) => e.value['postType'] == 'article')
          .map((e) => ArticleModel.fromMap(e.value))
          .toList(),
    );
  }

  static const empty = ArticlesResponse(
    pagesCount: 0,
    articleIds: [],
    models: [],
  );
  get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pagesCount, articleIds, models];
}
