import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/related_data/publication_vote_model.dart';
import '../../../../data/repository/repository.dart';

part 'publication_vote_bloc.freezed.dart';
part 'publication_vote_event.dart';
part 'publication_vote_state.dart';

class PublicationVoteBloc
    extends Bloc<PublicationVoteEvent, PublicationVoteState> {
  PublicationVoteBloc({
    required Publication publication,
    required this.repository,
  }) : super(
         PublicationVoteState(
           id: publication.id,
           score: publication.statistics.score,
           actionPlus: publication.relatedData.votePlus,
           actionMinus: publication.relatedData.voteMinus,
           votesCount: publication.statistics.votesCount,
           votesCountPlus: publication.statistics.votesCountPlus,
           votesCountMinus: publication.statistics.votesCountMinus,
           vote: publication.relatedData.vote.value,
         ),
       ) {
    on<_VoteUpEvent>(_onVoteUp);
    on<_VoteDownEvent>(_onVoteDown);
  }

  final PublicationVoteRepository repository;

  String? _commonValidation(PublicationVoteAction action) {
    if (action.isVotingOver) {
      return 'Голосование уже закончено';
    } else if (!action.isChargeEnough) {
      return 'Лимит голосов на сегодня исчерпан';
    } else if (!action.isKarmaEnough) {
      return 'Вам не хватает рейтинга для голосования';
    } else if (!action.canVote) {
      return 'Вы больше не можете голосовать';
    }

    return null;
  }

  FutureOr<void> _onVoteUp(
    _VoteUpEvent event,
    Emitter<PublicationVoteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading, error: null));

    final validationError = _commonValidation(state.actionPlus);
    if (validationError != null) {
      return emit(
        state.copyWith(status: LoadingStatus.failure, error: validationError),
      );
    }

    try {
      final result = await repository.voteUp(state.id);
      final newAction = state.actionPlus.copyWith(canVote: result.canVote);

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          actionPlus: newAction,
          score: result.score,
          votesCount: result.votesCount,
          votesCountPlus: state.votesCountPlus + 1,
          vote: result.vote.value,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          error: 'Не удалось повысить рейтинг',
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  /// TODO: неизвестно как работает понижение голосов
  FutureOr<void> _onVoteDown(
    _VoteDownEvent event,
    Emitter<PublicationVoteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading, error: null));

    return emit(
      state.copyWith(
        status: LoadingStatus.failure,
        error:
            'У разработчика не хватает сил ставить минусы на публикации, '
            'поэтому пока неизвестно, как работает понижение голосов',
      ),
    );

    // final validationError = _commonValidation(state.actionMinus);
    // if (validationError != null) {
    //   return emit(state.copyWith(
    //     status: LoadingStatus.failure,
    //     error: validationError,
    //   ));
    // }

    // try {
    //   final result = await repository.voteDown(state.id);
    //   final newAction = state.actionMinus.copyWith(canVote: result.canVote);

    //   emit(state.copyWith(
    //     status: LoadingStatus.success,
    //     actionMinus: newAction,
    //     score: result.score,
    //     votesCount: result.votesCount,
    //     votesCountMinus: state.votesCountMinus + 1,
    //     vote: result.vote.value,
    //   ));
    // } catch (error, stackTrace) {
    //   emit(state.copyWith(
    //     status: LoadingStatus.failure,
    //     error: 'Не удалось понизить рейтинг',
    //   ));

    //   super.onError(error, stackTrace);
    // }
  }
}
