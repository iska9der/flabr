import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../widget/enhancement/enhancement.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../stats/publication_stats_widget.dart';
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
    return FlabrCard(
      onTap:
          () => getIt<AppRouter>().navigate(
            PublicationFlowRoute(type: PublicationType.post.name, id: post.id),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (showType) PublicationTypeWidget(type: post.type),
          PublicationHeaderWidget(post),
          PublicationStatsWidget(post),
          PublicationHubsWidget(hubs: post.hubs),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen:
                (previous, current) =>
                    previous.feed.isImageVisible != current.feed.isImageVisible,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CardHtmlWidget(
                  textHtml: post.textHtml,
                  rebuildTriggers: [state.feed],
                  isImageVisible: state.feed.isImageVisible,
                ),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Теги', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    post.tags.map((tag) {
                      final style = Theme.of(context).textTheme.bodySmall;

                      return Text(tag, style: style);
                    }).toList(),
              ),
            ],
          ),
          PublicationFooterWidget(publication: post),
        ],
      ),
    );
  }
}
