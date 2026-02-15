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
    final theme = context.theme;

    return BlocListener<MostReadingCubit, MostReadingState>(
      listener: (context, state) {
        if (state.status == .success) {
          context.read<PublicationBookmarksBloc>().add(
            .updated(publications: state.publications),
          );
        }
      },
      child: BlocBuilder<MostReadingCubit, MostReadingState>(
        builder: (context, state) {
          if (state.status == .initial) {
            context.read<MostReadingCubit>().fetch();
          }

          if (state.status == .initial ||
              state.status == .loading ||
              state.status == .failure) {
            return const Padding(
              padding: .symmetric(vertical: 24),
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
                    margin: .zero,
                    padding: .symmetric(
                      horizontal: AppInsets.screenPadding.left,
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    onTap: () => appRouter.pushWidget(
                      PublicationDetailPage(
                        type: model.type.name,
                        id: model.id,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Padding(
                          padding: const .only(bottom: 4),
                          child: Text(
                            model.titleHtml,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        Row(
                          children: [
                            PublicationStatIconButton(
                              padding: .zero,
                              icon: Icons.remove_red_eye_rounded,
                              value: model.statistics.readingCount.compact(),
                            ),
                            PublicationStatIconButton(
                              icon: Icons.chat_bubble_rounded,
                              value: model.statistics.commentsCount.compact(),
                              isHighlighted:
                                  model.relatedData.unreadCommentsCount > 0,
                              onTap: () => context.router.push(
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
      ),
    );
  }
}
