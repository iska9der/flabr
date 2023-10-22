import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/model/extension/num.dart';
import '../../../common/widget/enhancement/app_expansion_panel.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../cubit/most_reading_cubit.dart';
import '../page/article_detail_page.dart';
import '../page/comment_list_page.dart';
import '../repository/article_repository.dart';
import 'stats/article_stat_icon_widget.dart';

class MostReadingWidget extends StatelessWidget {
  const MostReadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MostReadingCubit(getIt.get<ArticleRepository>()),
      child: const _MostReadingView(),
    );
  }
}

class _MostReadingView extends StatefulWidget {
  const _MostReadingView();

  @override
  State<_MostReadingView> createState() => _MostReadingViewState();
}

class _MostReadingViewState extends State<_MostReadingView> {
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
            if (!isExpanded) {
              context.read<MostReadingCubit>().fetch();
            }

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
              body: BlocBuilder<MostReadingCubit, MostReadingState>(
                builder: (context, state) {
                  if (state.status.isLoading || state.status.isFailure) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircleIndicator.medium(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(kScreenHPadding),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (c, i) => const SizedBox(height: 6),
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final model = state.articles[index];

                        return FlabrCard(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.fromLTRB(
                            kScreenHPadding,
                            6,
                            kScreenHPadding,
                            0,
                          ),
                          color: Colors.transparent,
                          elevation: 0,
                          onTap: () => context.router.pushWidget(
                            ArticleDetailPage(id: model.id),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.titleHtml,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  StatIconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icons.remove_red_eye_rounded,
                                    text:
                                        model.statistics.readingCount.compact(),
                                  ),
                                  StatIconButton(
                                    icon: Icons.chat_bubble_rounded,
                                    text: model.statistics.commentsCount
                                        .compact(),
                                    isHighlighted:
                                        model.relatedData.unreadCommentsCount >
                                            0,
                                    onTap: () => context.router.pushWidget(
                                      CommentListPage(articleId: model.id),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
