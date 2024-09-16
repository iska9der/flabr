import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../core/component/router/app_router.dart';
import '../../../../core/constants/environment.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/part.dart';
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

class _NotificationWidget extends StatelessWidget {
  // ignore: unused_element
  const _NotificationWidget({super.key, required this.model});

  final TrackerNotification model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = model.dataModel.user;
    final publication = model.dataModel.publication;

    return FlabrCard(
      color: model.unread ? theme.colorScheme.surfaceContainerHighest : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null) UserTextButton(user),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(text: model.typeEnum.text),
                  if (publication != null) ...[
                    const TextSpan(text: ' "'),
                    TextSpan(
                      text: publication.text.trim(),
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

class _UnknownWidget extends StatelessWidget {
  // ignore: unused_element
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
                    builder: (context) => const AlertDialog(
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
                      path: Environment.contactEmail,
                      queryParameters: {
                        'subject': '[Flabr]: Structure of [${model.type}]',
                        'body': model.toString(),
                      });

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
                      'domain': Environment.contactTelegram,
                      'text': model.toString(),
                    },
                  );

                  getIt<AppRouter>().launchUrl(uri.toString());
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
