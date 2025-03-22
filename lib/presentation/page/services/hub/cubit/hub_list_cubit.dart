import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/exception/exception.dart';
import '../../../../../data/model/hub/hub_model.dart';
import '../../../../../data/model/list_response/hub_list_response.dart';
import '../../../../../data/model/list_response_model.dart';
import '../../../../../data/repository/repository.dart';

part 'hub_list_state.dart';

class HubListCubit extends Cubit<HubListState> {
  HubListCubit({
    required HubRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       _languageRepository = languageRepository,
       super(const HubListState()) {
    _uiLangSub = _languageRepository.uiStream.listen((_) => _reInit());
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final HubRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articlesLangSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articlesLangSub.cancel();
    return super.close();
  }

  void fetch() async {
    if (state.status == HubListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: HubListStatus.loading));

    try {
      final response = await _repository.fetchAll(
        page: state.page,
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
      );

      var newList = state.list.copyWith(
        ids: [...state.list.ids, ...response.ids],
        pagesCount: response.pagesCount,
        refs: [...state.list.refs, ...response.refs],
      );

      emit(
        state.copyWith(
          status: HubListStatus.success,
          list: newList,
          page: state.page + 1,
        ),
      );
    } catch (error, stackTrace) {
      const fallbackMessage = 'Не удалось получить список хабов';
      emit(
        state.copyWith(
          status: HubListStatus.failure,
          error: error.parseException(fallbackMessage),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  void _reInit() {
    emit(const HubListState());
  }
}
