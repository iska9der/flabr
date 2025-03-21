part of '../card.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    required this.publication,
    this.isBlocked = true,
    super.key,
  });

  final Publication publication;
  final bool isBlocked;

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

        return _VoteButtons(publication: publication);
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
      showDuration: Duration(seconds: 5),
      message:
          'Всего голосов $votesCount: '
          '↑$votesCountPlus и ↓$votesCountMinus',
      child: child,
    );
  }
}

class _VoteButtons extends StatelessWidget {
  const _VoteButtons({
    // ignore: unused_element_parameter
    super.key,
    required this.publication,
  });

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    final iconStyle = IconButton.styleFrom(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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
            getIt<Utils>().showSnack(
              context: context,
              content: Text(state.error!),
            );
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
                icon: Icon(Icons.arrow_upward, size: 18),
                onPressed:
                    isLoading
                        ? null
                        : () => context.read<PublicationVoteBloc>().add(
                          PublicationVoteEvent.voteUp(),
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
                          PublicationVoteEvent.voteDown(),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
