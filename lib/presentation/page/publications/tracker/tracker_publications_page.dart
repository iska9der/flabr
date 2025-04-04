import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/router/app_router.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/tracker.dart';
import '../../../../di/di.dart';
import '../../../extension/extension.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/user_text_button.dart';
import '../widget/stats/stats.dart';
import 'bloc/tracker_publications_bloc.dart';
import 'bloc/tracker_publications_marker_bloc.dart';
import 'widget/tracker_skeleton_widget.dart';

@RoutePage(name: TrackerPublicationsPage.routeName)
class TrackerPublicationsPage extends StatelessWidget {
  const TrackerPublicationsPage({super.key});

  static const String routePath = '';
  static const String routeName = 'TrackerPublicationsRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  TrackerPublicationsBloc(repository: getIt())
                    ..add(const TrackerPublicationsEvent.subscribe()),
        ),
        BlocProvider(
          create: (_) => TrackerPublicationsMarkerBloc(repository: getIt()),
        ),
      ],
      child: const TrackerPublicationsView(),
    );
  }
}

class TrackerPublicationsView extends StatelessWidget {
  const TrackerPublicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const _TrackerFloatingButton(),
      body: BlocBuilder<TrackerPublicationsBloc, TrackerPublicationsState>(
        builder: (context, state) {
          if (state.status == LoadingStatus.initial) {
            context.read<TrackerPublicationsBloc>().add(
              const TrackerPublicationsEvent.load(),
            );
          }

          return switch (state.status) {
            LoadingStatus.failure => Center(child: Text(state.error)),
            LoadingStatus.success => ListView.builder(
              itemCount: state.response.refs.length,
              itemExtent: 150,
              itemBuilder: (context, index) {
                final model = state.response.refs[index];

                return TrackerPublicationWidget(
                  key: ValueKey('tracker-publication-${model.id}'),
                  model: model,
                );
              },
            ),
            _ => ListView(
              children: List.filled(6, const TrackerSkeletonWidget()),
            ),
          };
        },
      ),
    );
  }
}

class TrackerPublicationWidget extends StatefulWidget {
  const TrackerPublicationWidget({super.key, required this.model});

  final TrackerPublication model;

  @override
  State<TrackerPublicationWidget> createState() =>
      _TrackerPublicationWidgetState();
}

class _TrackerPublicationWidgetState extends State<TrackerPublicationWidget> {
  late bool isHighlighted = widget.model.isHighlighted;

  void markAsHighlighted() {
    isHighlighted = false;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TrackerPublicationWidget oldWidget) {
    if (oldWidget.model.isHighlighted != widget.model.isHighlighted) {
      isHighlighted = widget.model.isHighlighted;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FlabrCard(
      color: isHighlighted ? theme.colors.cardHighlight : null,
      onTap:
          () => context.router.push(
            PublicationFlowRoute(
              type: widget.model.publicationType,
              id: widget.model.id,
            ),
          ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserTextButton(widget.model.author),
                const Spacer(),
                Text(
                  widget.model.title.trim(),
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const Spacer(),
                Row(
                  children: [
                    PublicationStatIconButton(
                      icon: Icons.chat_bubble_rounded,
                      value: widget.model.commentsCount.compact(),
                      isHighlighted: widget.model.isHighlighted,
                      onTap: () {
                        context.router.push(
                          PublicationFlowRoute(
                            type: widget.model.publicationType,
                            id: widget.model.id,
                            children: [PublicationCommentRoute()],
                          ),
                        );

                        markAsHighlighted();
                      },
                    ),
                    if (widget.model.isHighlighted)
                      PublicationStatIconButton(
                        icon: Icons.add,
                        value: widget.model.unreadCommentsCount.compact(),
                        isHighlighted: true,
                        color: Colors.green,

                        /// TODO: onTap с навигацией до первого непрочитанного комментария
                      ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<
            TrackerPublicationsMarkerBloc,
            TrackerPublicationsMarkerState
          >(
            builder: (context, state) {
              return Checkbox(
                value: state.markedIds.keys.contains(widget.model.id),
                onChanged: (isChecked) {
                  context.read<TrackerPublicationsMarkerBloc>().add(
                    TrackerPublicationsMarkerEvent.mark(
                      id: widget.model.id,
                      isMarked: isChecked ?? false,
                      isUnreaded: widget.model.unreadCommentsCount > 0,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TrackerFloatingButton extends StatelessWidget {
  // ignore: unused_element_parameter
  const _TrackerFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final fabLoader = const CircleIndicator.small();
    final iconSize = fabLoader.size.height;

    return BlocBuilder<
      TrackerPublicationsMarkerBloc,
      TrackerPublicationsMarkerState
    >(
      builder: (context, state) {
        if (state.markedIds.isEmpty) {
          return const SizedBox.shrink();
        }

        final isLoading = state.status == LoadingStatus.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isAnyUnreaded)
              FilledButton.icon(
                label: const Text('Пометить как прочитанное'),
                icon:
                    isLoading
                        ? fabLoader
                        : Icon(Icons.mark_chat_read, size: iconSize),
                onPressed:
                    isLoading
                        ? null
                        : () => context
                            .read<TrackerPublicationsMarkerBloc>()
                            .add(const TrackerPublicationsMarkerEvent.read()),
              ),

            FilledButton.icon(
              label: const Text('Удалить из трекера'),
              icon: isLoading ? fabLoader : Icon(Icons.delete, size: iconSize),
              onPressed:
                  isLoading
                      ? null
                      : () => context.read<TrackerPublicationsMarkerBloc>().add(
                        const TrackerPublicationsMarkerEvent.remove(),
                      ),
            ),
          ],
        );
      },
    );
  }
}
