import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/di.dart';
import '../../../../core/component/router/app_router.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/app_expansion_panel.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../cubit/most_reading_cubit.dart';
import '../publication_detail_page.dart';
import 'stats/stats.dart';

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
    return FlabrCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
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

    return BlocBuilder<MostReadingCubit, MostReadingState>(
      builder: (context, state) {
        if (state.status == LoadingStatus.initial) {
          context.read<MostReadingCubit>().fetch();

          return SizedBox();
        }

        if (state.status == LoadingStatus.loading ||
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
