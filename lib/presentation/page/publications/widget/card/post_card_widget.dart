import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/settings/settings_cubit.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/enhancement/enhancement.dart';
import '../stats/publication_stat_widget.dart';
import 'card_html_widget.dart';
import 'components/footer_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';
import 'components/publication_type_widget.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    this.renderType = RenderType.plain,
    this.showType = false,
  });

  final PublicationPost post;
  final RenderType renderType;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return FlabrCard(
      onTap: () => getIt<AppRouter>().navigate(
        PublicationFlowRoute(type: PublicationType.post.name, id: post.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              if (showType) PublicationTypeWidget(type: post.type),
              Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PublicationHeaderWidget(post),
                  PublicationStat(
                    icon: Icons.remove_red_eye_rounded,
                    text: post.statistics.readingCount.compact(),
                  ),
                ],
              ),
              PublicationHubsWidget(hubs: post.hubs),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.feed.isImageVisible != current.feed.isImageVisible,
            builder: (context, state) {
              return CardHtmlWidget(
                textHtml: post.textHtml,
                rebuildTriggers: [state.feed],
                isImageVisible: state.feed.isImageVisible,
              );
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    'Теги:',
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ...post.tags.map(
                    (tag) => Text(tag, style: textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          PublicationFooterWidget(publication: post),
        ],
      ),
    );
  }
}
