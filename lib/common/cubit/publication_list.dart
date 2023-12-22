import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/publication/model/publication/publication.dart';

enum PublicationListStatus { initial, loading, success, failure }

abstract class PublicationListC<State extends PublicationListS>
    extends Cubit<State> {
  PublicationListC(super.initialState);

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  /// Получение списка публикаций
  FutureOr<void> fetch();
}

abstract interface class PublicationListS {
  PublicationListStatus get status;
  String get error;
  int get page;
  int get pagesCount;
  List<Publication> get publications;
}
