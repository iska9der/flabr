import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/language.dart';
import '../model/network/hub_list_response.dart';
import '../service/hub_service.dart';

part 'hub_list_state.dart';

class HubListCubit extends Cubit<HubListState> {
  HubListCubit(
    HubService service, {
    required LanguageEnum langUI,
    required List<LanguageEnum> langArticles,
  })  : _service = service,
        super(HubListState(langUI: langUI, langArticles: langArticles));

  final HubService _service;

  void fetch() async {
    if (state.status == HubListStatus.loading ||
        !state.isFirstFetch && state.isLastPage) {
      return;
    }

    emit(state.copyWith(status: HubListStatus.loading));

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
        status: HubListStatus.success,
        list: newList,
        page: state.page + 1,
      ));
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: HubListStatus.failure,
        error: e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HubListStatus.failure,
        error: 'Не удалось получить список хабов',
      ));
    }
  }

  void changeLanguage({
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
  }) {
    emit(HubListState(
      langUI: langUI ?? state.langUI,
      langArticles: langArticles ?? state.langArticles,
    ));
  }
}
