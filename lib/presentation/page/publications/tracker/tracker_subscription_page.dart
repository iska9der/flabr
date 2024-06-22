import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/part.dart';
import '../../../widget/card_avatar_widget.dart';
import '../../../widget/enhancement/card.dart';
import 'bloc/tracker_notifications_bloc.dart';
import 'widget/tracker_skeleton_widget.dart';

@RoutePage(name: TrackerSubscriptionPage.routeName)
class TrackerSubscriptionPage extends StatelessWidget {
  const TrackerSubscriptionPage({super.key});

  static const String routePath = 'notifications';
  static const String routeName = 'TrackerSubscriptionRoute';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackerNotificationsBloc(
        repository: getIt(),
        category: TrackerNotificationCategory.subscribers,
      ),
      child: const TrackerSubscriptionView(),
    );
  }
}

class TrackerSubscriptionView extends StatelessWidget {
  const TrackerSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackerNotificationsBloc, TrackerNotificationsState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == LoadingStatus.initial) {
            context
                .read<TrackerNotificationsBloc>()
                .add(const TrackerNotificationsEvent.load());
          }

          return switch (state.status) {
            LoadingStatus.failure => Center(child: Text(state.error)),
            LoadingStatus.success => ListView.builder(
                itemCount: state.response.list.refs.length,
                itemBuilder: (context, index) {
                  final model = state.response.list.refs[index];

                  return _NotificationWidget(model: model);
                },
              ),
            _ => ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const TrackerSkeletonWidget();
                },
              ),
          };
        },
      ),
    );
  }
}

class _NotificationWidget extends StatelessWidget {
  // ignore: unused_element
  const _NotificationWidget({super.key, required this.model});

  final TrackerNotification model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlabrCard(
      color: model.unread ? theme.colorScheme.surfaceContainerHighest : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.data.user != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:
                        CardAvatarWidget(imageUrl: model.data.user!.avatarUrl),
                  ),
                  Text(
                    model.data.user!.login,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(text: model.type.text),
                  if (model.data.publication != null) ...[
                    const TextSpan(text: ' "'),
                    TextSpan(
                      text: model.data.publication!.text.trim(),
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const TextSpan(text: '"'),
                  ],
                ],
              ),
            ),
          ),
          if (model.timeHappened != null)
            Text(
              DateFormat.MMMMd().format(model.timeHappened!),
            ),
        ],
      ),
    );
  }
}
