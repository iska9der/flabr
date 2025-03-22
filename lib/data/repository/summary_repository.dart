import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

@Singleton(as: SummaryRepository)
class SummaryRepositoryApp extends SummaryRepositoryImpl {
  SummaryRepositoryApp({required super.service});

  final Map<String, SummaryModel> cache = {};

  @override
  Future<SummaryModel> fetchSummary(String url) async {
    if (cache.containsKey(url)) {
      return cache[url]!;
    }

    final model = await super.fetchSummary(url);
    cache[url] = model;

    return model;
  }
}
