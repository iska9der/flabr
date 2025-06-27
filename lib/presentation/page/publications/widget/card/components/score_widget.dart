import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/publication/publication_vote_bloc.dart';
import '../../../../../../data/model/loading_status_enum.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../data/model/stat_type_enum.dart';
import '../../../../../../di/di.dart';
import '../../../../../../feature/auth/auth.dart';
import '../../../../../extension/extension.dart';
import '../../stats/publication_stat_icon_widget.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    required this.publication,
    this.isBlocked = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    super.key,
  });

  final Publication publication;
  final bool isBlocked;

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => !state.isAuthorized,
      builder: (context, isUnathorized) {
        if (isBlocked ||
            isUnathorized ||
            publication.relatedData.votePlus.isVotingOver) {
          final score = publication.statistics.score;
          final icon = switch (publication.relatedData.vote.value) {
            != null && > 0 => Icons.arrow_upward,
            != null && < 0 => Icons.arrow_downward,
            _ => Icons.insert_chart_rounded,
          };
          final color = switch (score) {
            >= 0 => StatType.score.color,
            _ => StatType.score.negativeColor,
          };

          return _ScoreTooltip(
            votesCount: publication.statistics.votesCount,
            votesCountPlus: publication.statistics.votesCountPlus,
            votesCountMinus: publication.statistics.votesCountMinus,
            child: PublicationStatIconButton(
              icon: icon,
              value: score.compact(),
              isHighlighted: true,
              color: color,
            ),
          );
        }

        return _VoteButtons(
          publication: publication,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        );
      },
    );
  }
}

class _ScoreTooltip extends StatelessWidget {
  const _ScoreTooltip({
    // ignore: unused_element_parameter
    super.key,
    this.votesCount = 0,
    this.votesCountPlus = 0,
    this.votesCountMinus = 0,
    required this.child,
  });

  final int votesCount;
  final int votesCountPlus;
  final int votesCountMinus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 5),
      message:
          'Всего голосов $votesCount: '
          '↑$votesCountPlus и ↓$votesCountMinus',
      child: child,
    );
  }
}

class _VoteButtons extends StatelessWidget {
  const _VoteButtons({
    required this.publication,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,

    // ignore: unused_element_parameter
    super.key,
  });

  final Publication publication;

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final iconStyle = IconButton.styleFrom(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      minimumSize: const Size(36, double.infinity),
    );

    return BlocProvider(
      create:
          (_) => PublicationVoteBloc(
            publication: publication,
            repository: getIt(),
          ),
      child: BlocConsumer<PublicationVoteBloc, PublicationVoteState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.failure && state.error != null) {
            context.showSnack(content: Text(state.error!));
          }
        },
        builder: (context, state) {
          final isLoading = state.status == LoadingStatus.loading;
          final score = state.score;
          final color = switch (score) {
            >= 0 => StatType.score.color,
            _ => StatType.score.negativeColor,
          };

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                style: iconStyle,
                tooltip: 'Повысить рейтинг',
                icon: const Icon(Icons.arrow_upward, size: 18),
                onPressed:
                    isLoading
                        ? null
                        : () => context.read<PublicationVoteBloc>().add(
                          const PublicationVoteEvent.voteUp(),
                        ),
              ),
              _ScoreTooltip(
                votesCount: state.votesCount,
                votesCountPlus: state.votesCountPlus,
                votesCountMinus: state.votesCountMinus,
                child: SizedBox(
                  width: 40,
                  child: Text(
                    score.compact(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                style: iconStyle,
                tooltip: 'Понизить рейтинг',
                icon: Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
                onPressed:
                    isLoading
                        ? null
                        : () => context.read<PublicationVoteBloc>().add(
                          const PublicationVoteEvent.voteDown(),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
