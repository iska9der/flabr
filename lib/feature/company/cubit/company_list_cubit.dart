import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../model/network/company_list_response.dart';
import '../service/company_service.dart';

part 'company_list_state.dart';

class CompanyListCubit extends Cubit<CompanyListState> {
  CompanyListCubit(
    CompanyService service, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(CompanyListState(langUI: langUI, langArticles: langArticles));

  final CompanyService _service;

  void fetch() async {
    if (state.status == CompanyListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: CompanyListStatus.loading));

    try {
      final response = await _service.fetchAll(
        page: state.page,
        langUI: state.langUI,
        langArticles: state.langArticles,
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

  void changeLanguage({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(CompanyListState(
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
