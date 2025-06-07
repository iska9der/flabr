import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/user/user.dart';
import '../../data/repository/repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(String login, {required UserRepository repository})
    : _repository = repository,
      super(UserState(login: login, model: User.empty));

  final UserRepository _repository;

  void fetchCard() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      User model = state.model;

      if (model.isEmpty) {
        model = await _repository.fetchCard(login: state.login);
      }

      emit(state.copyWith(status: UserStatus.success, model: model));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          error: error.parseException(
            'Не удалось получить карточку пользователя',
          ),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  void fetchWhois() async {
    UserWhois model;

    if (state.whoisModel.isEmpty) {
      model = await _repository.fetchWhois(login: state.login);
    } else {
      model = state.whoisModel;
    }

    emit(state.copyWith(whoisModel: model));
  }
}
