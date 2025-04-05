import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/company/company.dart';
import '../../data/model/language/language.dart';
import '../../data/model/list_response_model.dart';
import '../../data/repository/repository.dart';

part 'company_list_state.dart';

class CompanyListCubit extends Cubit<CompanyListState> {
  CompanyListCubit({
    required CompanyRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       _languageRepository = languageRepository,
       super(const CompanyListState()) {
    _uiLangSub = _languageRepository.uiStream.listen((_) => _reInit());
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final CompanyRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription<Language> _uiLangSub;
  late final StreamSubscription<List<Language>> _articlesLangSub;

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
        pagesCount: response.pagesCount,
        ids: [...state.list.ids, ...response.ids],
        refs: [...state.list.refs, ...response.refs],
      );

      emit(
        state.copyWith(
          status: CompanyListStatus.success,
          list: newList,
          page: state.page + 1,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: CompanyListStatus.failure,
          error: error.parseException('Не удалось получить список компаний'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  void _reInit() {
    emit(const CompanyListState());
  }
}
