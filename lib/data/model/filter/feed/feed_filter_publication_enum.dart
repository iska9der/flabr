part of '../part.dart';

enum FeedFilterPublication {
  articles(label: 'Статьи'),
  posts(label: 'Посты'),
  news(label: 'Новости'),
  ;

  const FeedFilterPublication({required this.label});

  final String label;
}
