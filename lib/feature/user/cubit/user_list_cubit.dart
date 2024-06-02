import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/exception_helper.dart';
import '../../../data/repository/repository_part.dart';
import '../model/user_model.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({
    required UserRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(const UserListState()) {
    _uiLangSub = _languageRepository.uiStream.listen(
      (_) => _reInit(),
    );
    _articlesLangSub = _languageRepository.articlesStream.listen(
      (_) => _reInit(),
    );
  }

  final UserRepository _repository;
  final LanguageRepository _languageRepository;

  late final StreamSubscription _uiLangSub;
  late final StreamSubscription _articlesLangSub;

  @override
  Future<void> close() {
    _uiLangSub.cancel();
    _articlesLangSub.cancel();
    return super.close();
  }

  bool get isFirstFetch => state.page == 1;
  bool get isLastPage => state.page >= state.pagesCount;

  void fetchAll() async {
    if (state.status == UserListStatus.loading || !isFirstFetch && isLastPage) {
      return;
    }

    emit(state.copyWith(status: UserListStatus.loading));

    try {
      var response = await _repository.fetchAll(
        langUI: _languageRepository.ui,
        langArticles: _languageRepository.articles,
        page: state.page.toString(),
      );

      emit(state.copyWith(
        status: UserListStatus.success,
        users: [...state.users, ...response.refs],
        page: state.page + 1,
        pagesCount: response.pagesCount,
      ));
    } catch (e) {
      const fallbackMessage = 'Не удалось получить пользователей';

      emit(state.copyWith(
        error: ExceptionHelper.parseMessage(e, fallbackMessage),
        status: UserListStatus.failure,
      ));
    }
  }

  void _reInit() {
    emit(const UserListState());
  }
}
