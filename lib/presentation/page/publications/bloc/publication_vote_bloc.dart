import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/publication/publication_vote_response.dart';
import '../../../../data/model/related_data/publication_vote_model.dart';
import '../../../../data/repository/part.dart';

part 'publication_vote_bloc.freezed.dart';
part 'publication_vote_event.dart';
part 'publication_vote_state.dart';

class PublicationVoteBloc
    extends Bloc<PublicationVoteEvent, PublicationVoteState> {
  PublicationVoteBloc(this.repository) : super(PublicationVoteState()) {
    on<PublicationVoteUpEvent>(_onVoteUp);
    on<PublicationVoteDownEvent>(_onVoteDown);
  }

  final PublicationRepository repository;

  String? _commonValidation(PublicationVoteEvent event) {
    if (event.vote.isVotingOver) {
      return 'Голосование уже закончено';
    } else if (!event.vote.isChargeEnough) {
      return 'Лимит голосов на сегодня исчерпан';
    } else if (!event.vote.isKarmaEnough) {
      return 'Вам не хватает очков профиля на это действие';
    }

    return null;
  }

  FutureOr<void> _onVoteUp(
    PublicationVoteUpEvent event,
    Emitter<PublicationVoteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final validationError = _commonValidation(event);
    if (validationError != null) {
      return emit(state.copyWith(
        status: LoadingStatus.failure,
        error: validationError,
      ));
    }

    try {
      final result = await repository.voteUp(event.id);

      emit(state.copyWith(status: LoadingStatus.success, result: result));
    } catch (error, stackTrace) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        error: 'Не удалось повысить рейтинг',
      ));

      super.onError(error, stackTrace);
    }
  }

  /// TODO: неизвестно как работает понижение голосов
  /// (не хватает "кармы")
  FutureOr<void> _onVoteDown(
    PublicationVoteDownEvent event,
    Emitter<PublicationVoteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    return emit(state.copyWith(
      status: LoadingStatus.failure,
      error: 'Разработчику пока неизвестно, как работает понижение голосов :(',
    ));

    // final validationError = _commonValidation(event);
    // if (validationError != null) {
    //   return emit(state.copyWith(
    //     status: LoadingStatus.failure,
    //     error: validationError,
    //   ));
    // }

    // try {
    //   final result = await repository.voteDown(event.id);

    //   emit(state.copyWith(status: LoadingStatus.success, result: result));
    // } catch (error, stackTrace) {
    //   emit(state.copyWith(
    //     status: LoadingStatus.failure,
    //     error: 'Не удалось понизить рейтинг',
    //   ));

    //   super.onError(error, stackTrace);
    // }
  }
}
