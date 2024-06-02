import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../data/repository/repository_part.dart';
import '../model/network/company_list_response.dart';

part 'company_list_state.dart';

class CompanyListCubit extends Cubit<CompanyListState> {
  CompanyListCubit({
    required CompanyRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(const CompanyListState()) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => _reInit(),
    );
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final CompanyRepository _repository;
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
    if (state.status == CompanyListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: CompanyListStatus.loading));

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

      emit(state.copyWith(
        status: CompanyListStatus.success,
        list: newList,
        page: state.page + 1,
      ));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: CompanyListStatus.failure,
        error: e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CompanyListStatus.failure,
        error: 'Не удалось получить список компайний',
      ));
    }
  }

  void _reInit() {
    emit(const CompanyListState());
  }
}
