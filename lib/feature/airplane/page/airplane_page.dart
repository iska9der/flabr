import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/publication/publication.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/page/publications/widget/publication_detail_view.dart';
import '../../../presentation/widget/enhancement/enhancement.dart';
import '../../../presentation/widget/error_widget.dart';
import '../bloc/bloc.dart';
import '../model/publication_offline.dart';

@RoutePage()
class AirplanePage extends StatelessWidget {
  const AirplanePage({super.key});

  static const String routePath = 'airplane';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сохранённые статьи'),
      ),
      body: BlocListener<OfflinePublicationBloc, OfflinePublicationState>(
        listenWhen: (previous, current) =>
            previous.operationError != current.operationError &&
            current.operationError != null,
        listener: (context, state) {
          context.showSnack(content: Text(state.operationError!));
        },
        child: BlocBuilder<OfflinePublicationBloc, OfflinePublicationState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.publications != current.publications ||
              previous.loadingIds != current.loadingIds,
          builder: (context, state) => switch (state.status) {
            LoadingStatus.initial ||
            LoadingStatus.loading => const Center(child: CircleIndicator()),
            LoadingStatus.failure when state.publications.isEmpty => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppError(
                  message:
                      state.error ?? 'Не удалось открыть сохранённые статьи',
                  onRetry: () => context.read<OfflinePublicationBloc>().add(
                    const OfflinePublicationEvent.load(),
                  ),
                ),
              ),
            ),
            _ when state.publications.isEmpty => const _EmptyView(),
            _ => _PublicationList(
              publications: state.publications,
              loadingIds: state.loadingIds,
            ),
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.airplanemode_active_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Здесь пока пусто',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Сохраняйте статьи через меню публикации — текст и доступные '
              'изображения останутся на устройстве.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicationList extends StatelessWidget {
  const _PublicationList({
    required this.publications,
    required this.loadingIds,
  });

  final List<PublicationOffline> publications;
  final Set<String> loadingIds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: publications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final saved = publications[index];
        final publication = saved.publication;
        final isLoading = loadingIds.contains(publication.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openPublication(context, publication),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleOf(publication),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _metadataOf(context, saved),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Удалить из оффлайна',
                    onPressed: isLoading
                        ? null
                        : () => context.read<OfflinePublicationBloc>().add(
                            OfflinePublicationEvent.setSaved(
                              publication: publication,
                              saved: false,
                            ),
                          ),
                    icon: isLoading
                        ? const CircleIndicator.small()
                        : const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openPublication(BuildContext context, Publication publication) {
    context.router.pushWidget(
      Scaffold(
        body: SafeArea(child: PublicationDetailView(publication: publication)),
      ),
    );
  }

  String _metadataOf(BuildContext context, PublicationOffline saved) {
    final author = saved.publication.author;
    final authorName = author.fullname.isNotEmpty
        ? author.fullname
        : author.alias;
    final date = MaterialLocalizations.of(
      context,
    ).formatShortDate(saved.savedAt);
    return [
      if (authorName.isNotEmpty) authorName,
      'сохранено $date',
    ].join(' · ');
  }

  String _titleOf(Publication publication) {
    final title = switch (publication) {
      PublicationCommon common => common.titleHtml,
      _ => '',
    };
    final plainTitle = title
        .replaceAll(RegExp('<[^>]*>'), '')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .trim();
    return plainTitle.isEmpty
        ? '${publication.type.label} №${publication.id}'
        : plainTitle;
  }
}
