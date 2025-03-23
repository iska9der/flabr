part of 'most_reading_widget.dart';

class _ListView extends StatefulWidget {
  const _ListView();

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return BlocBuilder<MostReadingCubit, MostReadingState>(
      builder: (context, state) {
        if (state.status == LoadingStatus.initial) {
          context.read<MostReadingCubit>().fetch();
        }

        if (state.status == LoadingStatus.initial ||
            state.status == LoadingStatus.loading ||
            state.status == LoadingStatus.failure) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircleIndicator.medium(),
          );
        }
        return Padding(
          padding: AppInsets.screenPadding,
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: ListView.separated(
              controller: controller,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (c, i) => const SizedBox(height: 18),
              itemCount: state.publications.length,
              itemBuilder: (itemContext, index) {
                final model = state.publications[index];

                return FlabrCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  onTap:
                      () => appRouter.pushWidget(
                        PublicationDetailPage(
                          type: model.type.name,
                          id: model.id,
                        ),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          model.titleHtml,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Row(
                        children: [
                          PublicationStatIconButton(
                            padding: EdgeInsets.zero,
                            icon: Icons.remove_red_eye_rounded,
                            value: model.statistics.readingCount.compact(),
                          ),
                          PublicationStatIconButton(
                            icon: Icons.chat_bubble_rounded,
                            value: model.statistics.commentsCount.compact(),
                            isHighlighted:
                                model.relatedData.unreadCommentsCount > 0,
                            onTap:
                                () => context.router.push(
                                  PublicationFlowRoute(
                                    type: model.type.name,
                                    id: model.id,
                                    children: [PublicationCommentRoute()],
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
