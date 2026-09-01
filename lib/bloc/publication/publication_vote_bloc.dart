import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/loading_status_enum.dart';
import '../../data/model/publication/publication.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'publication_vote_bloc.freezed.dart';
part 'publication_vote_event.dart';
part 'publication_vote_state.dart';

class PublicationVoteBloc
    extends Bloc<PublicationVoteEvent, PublicationVoteState> {
  PublicationVoteBloc({
    required Publication publication,
    required this._repository,
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
    on<PublicationVoteEvent>(
      (event, emit) => switch (event) {
        _VoteUpEvent event => _voteUp(event, emit),
        _VoteDownEvent event => _voteDown(event, emit),
      },
    );
  }

  final PublicationVoteRepository _repository;

  AppFailure? _commonValidation(PublicationVoteAction action) {
    if (action.isVotingOver) {
      return const AppFailure(.publicationVotingEnded);
    } else if (!action.isChargeEnough) {
      return const AppFailure(.publicationDailyVoteLimitReached);
    } else if (!action.isKarmaEnough) {
      return const AppFailure(.publicationInsufficientRatingToVote);
    } else if (!action.canVote) {
      return const AppFailure(.publicationVotingNoLongerAllowed);
    }

    return null;
  }

  FutureOr<void> _voteUp(
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
      final result = await _repository.voteUp(state.id);
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
          error: const AppFailure(.publicationUpvoteFailed),
        ),
      );

      super.onError(error, stackTrace);
    }
  }

  /// TODO: неизвестно как работает понижение голосов
  FutureOr<void> _voteDown(
    _VoteDownEvent event,
    Emitter<PublicationVoteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading, error: null));

    return emit(
      state.copyWith(
        status: LoadingStatus.failure,
        error: const AppFailure(.publicationDownvoteUnavailable),
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
