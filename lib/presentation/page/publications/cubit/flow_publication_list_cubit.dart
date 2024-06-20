import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/component/storage/part.dart';
import '../../../../core/constants/part.dart';
import '../../../../data/exception/part.dart';
import '../../../../data/model/filter/part.dart';
import '../../../../data/model/list_response/list_response_model.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../../data/model/section_enum.dart';
import '../../../feature/publication_list/part.dart';

part 'flow_publication_list_state.dart';

class FlowPublicationListCubit
    extends PublicationListCubit<FlowPublicationListState> {
  FlowPublicationListCubit({
    required super.repository,
    required super.languageRepository,
    required this.storage,
    PublicationFlow flow = PublicationFlow.all,
    Section section = Section.article,
  }) : super(FlowPublicationListState(
          flow: flow,
          section: section,
        )) {
    _restoreFilter();
  }

  final CacheStorage storage;

  Future<void> _restoreFilter() async {
    emit(state.copyWith(status: PublicationListStatus.loading));

    final key = CacheKey.flowFilter(state.section.name);
    FlowPublicationListState newState = state;
    try {
      /// вспоминаем последний примененный фильтр во флоу
      final str = await storage.read(key);
      if (str == null) {
        throw NotFoundException();
      }

      final lastFilter = FlowFilter.fromJson(jsonDecode(str));
      newState = newState.copyWith(filter: lastFilter);
    } catch (_) {
      storage.delete(key);
    } finally {
      emit(newState.copyWith(status: PublicationListStatus.initial));
    }
  }

  @override
  Future<void> fetch() async {
    if (fetchDisabled) {
      return;
    }

    emit(state.copyWith(status: PublicationListStatus.loading));

    try {
      ListResponse response = await repository.fetchFlowArticles(
        langUI: languageRepository.ui,
        langArticles: languageRepository.articles,
        section: state.section,
        flow: state.flow,
        filter: state.filter,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: PublicationListStatus.success,
        publications: [...state.publications, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, 'Не удалось получить статьи'),
        status: PublicationListStatus.failure,
      ));

      rethrow;
    }
  }

  @override
  void refetch() {
    emit(state.copyWith(
      status: PublicationListStatus.initial,
      page: 1,
      publications: [],
      pagesCount: 0,
    ));
  }

  void changeFlow(PublicationFlow value) {
    if (state.flow == value) return;

    emit(FlowPublicationListState(
      flow: value,
      section: state.section,
    ));
  }

  void applyFilter(FlowFilter newFilter) {
    if (state.filter == newFilter) {
      return;
    }

    storage.write(
      CacheKey.flowFilter(state.section.name),
      jsonEncode(newFilter),
    );

    emit(FlowPublicationListState(
      flow: state.flow,
      section: state.section,
      filter: newFilter,
    ));
  }
}
