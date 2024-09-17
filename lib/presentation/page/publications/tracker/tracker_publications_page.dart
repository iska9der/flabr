import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../core/component/router/app_router.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/part.dart';
import '../../../extension/part.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/user_text_button.dart';
import '../widget/stats/part.dart';
import 'bloc/tracker_publications_bloc.dart';
import 'bloc/tracker_publications_remover_bloc.dart';
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
          create: (_) => TrackerPublicationsBloc(repository: getIt()),
        ),
        BlocProvider(
          create: (_) => TrackerPublicationsRemoverBloc(repository: getIt()),
        ),
      ],
      child: BlocListener<TrackerPublicationsRemoverBloc,
          TrackerPublicationsRemoverState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          return switch (state.status) {
            /// при успешном удалении публикаций из трекера перезагружаем
            /// список публикаций
            LoadingStatus.success => context
                .read<TrackerPublicationsBloc>()
                .add(const TrackerPublicationsEvent.load()),
            _ => null,
          };
        },
        child: const TrackerPublicationsView(),
      ),
    );
  }
}

class TrackerPublicationsView extends StatelessWidget {
  const TrackerPublicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<TrackerPublicationsRemoverBloc,
          TrackerPublicationsRemoverState>(
        builder: (context, state) {
          if (state.markedIds.isEmpty) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            label: const Text('Удалить из трекера'),
            icon: state.status == LoadingStatus.loading
                ? const CircleIndicator.medium()
                : const Icon(Icons.delete),
            onPressed: () {
              context
                  .read<TrackerPublicationsRemoverBloc>()
                  .add(const TrackerPublicationsRemoverEvent.remove());
            },
          );
        },
      ),
      body: BlocBuilder<TrackerPublicationsBloc, TrackerPublicationsState>(
        builder: (context, state) {
          if (state.status == LoadingStatus.initial) {
            context
                .read<TrackerPublicationsBloc>()
                .add(const TrackerPublicationsEvent.load());
          }

          return switch (state.status) {
            LoadingStatus.failure => Center(child: Text(state.error)),
            LoadingStatus.success => ListView.builder(
                itemCount: state.response.list.refs.length,
                itemBuilder: (context, index) {
                  final model = state.response.list.refs[index];

                  return TrackerPublicationWidget(model: model);
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
  const TrackerPublicationWidget({
    super.key,
    required this.model,
  });

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlabrCard(
      color: isHighlighted ? theme.colorScheme.surfaceContainerHighest : null,
      onTap: () => context.router.push(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.model.title.trim(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
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
                )
              ],
            ),
          ),
          BlocBuilder<TrackerPublicationsRemoverBloc,
              TrackerPublicationsRemoverState>(
            builder: (context, state) {
              return Checkbox(
                value: state.markedIds.contains(widget.model.id),
                onChanged: (isChecked) {
                  context.read<TrackerPublicationsRemoverBloc>().add(
                        TrackerPublicationsRemoverEvent.mark(
                          id: widget.model.id,
                          isMarked: isChecked ?? false,
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
