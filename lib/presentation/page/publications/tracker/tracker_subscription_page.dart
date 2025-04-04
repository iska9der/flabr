import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/component/router/app_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/tracker.dart';
import '../../../../di/di.dart';
import '../../../extension/extension.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/user_text_button.dart';
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
      create:
          (_) => TrackerNotificationsBloc(
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
            context.read<TrackerNotificationsBloc>().add(
              const TrackerNotificationsEvent.load(),
            );
          }

          return switch (state.status) {
            LoadingStatus.failure => Center(child: Text(state.error)),
            LoadingStatus.success => ListView.builder(
              itemCount: state.response.list.refs.length,
              itemExtent: 150,
              itemBuilder: (context, index) {
                final model = state.response.list.refs[index];

                if (model.typeEnum == TrackerNotificationType.unknown) {
                  return _UnknownWidget(model: model);
                }

                return _NotificationWidget(model: model);
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

class _NotificationWidget extends StatefulWidget {
  // ignore: unused_element_parameter
  const _NotificationWidget({super.key, required this.model});

  final TrackerNotification model;

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget> {
  @override
  void initState() {
    super.initState();
  }

  void markAsRead(BuildContext context, String id) {
    context.read<TrackerNotificationsBloc>().add(
      TrackerNotificationsEvent.read(ids: [id]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final user = widget.model.dataModel.user;
    final publication = widget.model.dataModel.publication;
    final isUnread = context.select<TrackerNotificationsBloc, bool>(
      (bloc) => bloc.state.isUnreaded(widget.model.id),
    );

    return FlabrCard(
      color: isUnread ? theme.colors.cardHighlight : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null) UserTextButton(user),
          const Spacer(),
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(text: widget.model.typeEnum.text),
                if (publication != null) ...[
                  const TextSpan(text: ' "'),
                  TextSpan(
                    text: publication.text.trim(),
                    style: TextStyle(color: theme.colorScheme.primary),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            markAsRead(context, widget.model.id);

                            context.router.push(
                              PublicationFlowRoute(
                                id: publication.id,
                                type: publication.type,
                              ),
                            );
                          },
                  ),
                  const TextSpan(text: '"'),
                ],
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.model.timeHappened != null
                    ? Text(
                      DateFormat.MMMMd().format(widget.model.timeHappened!),
                    )
                    : const SizedBox.shrink(),
                isUnread
                    ? Tooltip(
                      message: 'Отметить как прочитанное',
                      child: GestureDetector(
                        child: Icon(
                          Icons.circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        onTap: () => markAsRead(context, widget.model.id),
                      ),
                    )
                    : const SizedBox.square(dimension: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnknownWidget extends StatelessWidget {
  // ignore: unused_element_parameter
  const _UnknownWidget({super.key, required this.model});

  final TrackerNotification model;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALLO?! KTO ETA???',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Text('Этот тип уведомления разыскивается разработчиком!'),
          Row(
            children: [
              FilledButton.icon(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                icon: const Icon(Icons.question_mark_outlined),
                label: const Text('Подробнее'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => const AlertDialog(
                          content: Text(
                            'Чтобы отобразить данные - нужно знать, как они выглядят.\n'
                            'Уведомления такого типа ко мне не приходили, поэтому '
                            'мне нужна твоя небольшая помощь:\n'
                            'по нажатию на иконку почты или телеги скопируется структура '
                            'этого уведомления и тебя перенаправит в приложение.\n'
                            'Отправь сообщение, и никто не пострадает. Спасибо!',
                          ),
                        ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.attach_email),
                onPressed: () {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: AppEnvironment.contactEmail,
                    queryParameters: {
                      'subject': '[Flabr]: Structure of [${model.type}]',
                      'body': model.toString(),
                    },
                  );

                  getIt<AppRouter>().launchUrl(uri.toString());
                },
              ),
              IconButton(
                icon: const Icon(Icons.telegram_outlined),
                onPressed: () {
                  final uri = Uri(
                    scheme: 'tg',
                    path: 'resolve',
                    queryParameters: {
                      'domain': AppEnvironment.contactTelegram,
                      'text': model.toString(),
                    },
                  );

                  getIt<AppRouter>().launchUrl(uri.toString());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
