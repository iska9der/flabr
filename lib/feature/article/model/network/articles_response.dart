// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../article_model.dart';

class ArticlesResponse extends Equatable {
  const ArticlesResponse({
    required this.pagesCount,
    required this.articleIds,
    required this.articles,
  });

  final int pagesCount;
  final List<String> articleIds;
  final List<ArticleModel> articles;

  ArticlesResponse copyWith({
    int? pagesCount,
    List<String>? articleIds,
    List<ArticleModel>? articles,
  }) {
    return ArticlesResponse(
      pagesCount: pagesCount ?? this.pagesCount,
      articleIds: articleIds ?? this.articleIds,
      articles: articles ?? this.articles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pagesCount': pagesCount,
      'articleIds': articleIds,
      'articleRefs': articles,
    };
  }

  factory ArticlesResponse.fromMap(Map<String, dynamic> map) {
    return ArticlesResponse(
      pagesCount: map['pagesCount'] ?? 0,
      articleIds: List<String>.from((map['articleIds'])),
      articles: Map.from((map['articleRefs'] as Map))
          .entries

          /// только статьи, новости откидываем
          .where((e) => e.value['postType'] == 'article')
          .map((e) => ArticleModel.fromMap(e.value))
          .toList()
          .reversed
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticlesResponse.fromJson(String source) =>
      ArticlesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = ArticlesResponse(
    pagesCount: 0,
    articleIds: [],
    articles: [],
  );
  get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pagesCount, articleIds, articles];
}
