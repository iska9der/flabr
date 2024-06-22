import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../core/component/router/app_router.dart';
import '../../../extension/part.dart';
import '../../../theme/part.dart';
import '../../../widget/enhancement/app_expansion_panel.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../articles/article_detail_page.dart';
import '../cubit/most_reading_cubit.dart';
import 'stats/part.dart';

class MostReadingWidget extends StatelessWidget {
  const MostReadingWidget({super.key}) : isButton = false;
  const MostReadingWidget.button({super.key}) : isButton = true;

  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MostReadingCubit(getIt()),
      child: isButton ? const _MostReadingButton() : const _MostReadingList(),
    );
  }
}

class _MostReadingButton extends StatefulWidget {
  const _MostReadingButton();

  @override
  State<_MostReadingButton> createState() => _MostReadingButtonState();
}

class _MostReadingButtonState extends State<_MostReadingButton> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(kBorderRadiusDefault),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadiusDefault),
        child: AppExpansionPanelList(
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              isShow = !isExpanded;
            });
          },
          children: [
            AppExpansionPanel(
              isExpanded: isShow,
              canTapOnHeader: true,
              backgroundColor: Colors.transparent,
              headerBuilder: (context, isExpanded) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Читают сейчас',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                );
              },
              body: const _MostReadingList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MostReadingList extends StatefulWidget {
  const _MostReadingList();

  @override
  State<_MostReadingList> createState() => _MostReadingListState();
}

class _MostReadingListState extends State<_MostReadingList> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    context.read<MostReadingCubit>().fetch();

    return BlocBuilder<MostReadingCubit, MostReadingState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isFailure) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CircleIndicator.medium(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(kScreenHPadding),
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: ListView.separated(
              controller: controller,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (c, i) => const SizedBox(height: 18),
              itemCount: state.articles.length,
              itemBuilder: (itemContext, index) {
                final model = state.articles[index];

                return FlabrCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kScreenHPadding,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  onTap: () => appRouter.pushWidget(
                    ArticleDetailPage(id: model.id),
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
                            onTap: () => context.router.push(
                              PublicationRouter(
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
