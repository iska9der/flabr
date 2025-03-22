import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/publication/publication.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/enhancement/enhancement.dart';
import '../../../../widget/user_text_button.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../stats/stats.dart';
import 'components/hubs_widget.dart';

class SkeletonCardWidget extends StatelessWidget {
  const SkeletonCardWidget({
    super.key,
    this.authorAlias = 'Author placeholder',
    this.title = 'Title placeholder',
    this.description = 'Some useless description of the card',
  });

  final String authorAlias;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserTextButton(PublicationAuthor(id: '0', alias: authorAlias)),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: PublicationHubsWidget(
              hubs: List.filled(3, PublicationHub.empty),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen:
                    (p, c) => p.feed.isImageVisible != c.feed.isImageVisible,
                builder: (context, state) {
                  if (!state.feed.isImageVisible) {
                    return const SizedBox();
                  }

                  return const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: SizedBox(
                      height: AppDimensions.imageHeight,
                      child: ColoredBox(color: Colors.white),
                    ),
                  );
                },
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen:
                    (previous, current) =>
                        previous.feed.isDescriptionVisible !=
                            current.feed.isDescriptionVisible ||
                        previous.feed.isImageVisible !=
                            current.feed.isImageVisible,
                builder: (context, state) {
                  if (!state.feed.isDescriptionVisible) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                    child: Text(description),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PublicationStatIconButton(
                icon: Icons.insert_chart_rounded,
                value: 'val',
                isHighlighted: true,
              ),
              PublicationStatIconButton(
                icon: Icons.insert_chart_rounded,
                value: 'val',
                isHighlighted: true,
              ),
              PublicationStatIconButton(
                icon: Icons.insert_chart_rounded,
                value: 'val',
                isHighlighted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
