import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/company/company.dart';
import '../../data/model/list_response_model.dart';
import '../../data/repository/repository.dart';

part 'company_list_state.dart';

class CompanyListCubit extends Cubit<CompanyListState> {
  CompanyListCubit({
    required CompanyRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       super(const CompanyListState());

  final CompanyRepository _repository;

  void fetch() async {
    if (state.status == CompanyListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: CompanyListStatus.loading));

    try {
      final response = await _repository.fetchAll(page: state.page);

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
}
