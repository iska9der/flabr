import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/company/company.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.model,
    this.renderType = RenderType.plain,
  });

  final Company model;
  final RenderType renderType;

  moveToDetails(BuildContext context) {
    getIt<AppRouter>().navigate(CompanyDashboardRoute(alias: model.alias));
  }

  @override
  Widget build(BuildContext context) {
    final stats = model.statistics as CompanyStatistics;
    final hubLinkStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlabrCard(
          onTap: () => moveToDetails(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardAvatarWidget(imageUrl: model.imageUrl, height: 60),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardTitleWidget(
                          title: model.titleHtml,
                          renderType: renderType,
                        ),
                        HtmlWidget(
                          model.descriptionHtml,
                          textStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Пишет в хабы:'),
              Wrap(
                spacing: 14,
                children:
                    model.commonHubs.map((hub) {
                      var title = hub.title;
                      if (hub.isProfiled) {
                        title += '*';
                      }

                      final route =
                          switch (hub.type.isCorporative) {
                                true => CompanyDashboardRoute(alias: hub.alias),
                                false => HubDashboardRoute(alias: hub.alias),
                              }
                              as PageRouteInfo;

                      return InkWell(
                        onTap: () => getIt<AppRouter>().navigate(route),
                        borderRadius: AppStyles.borderRadius,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(title, style: hubLinkStyle),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ProfileStatCardWidget(
                  type: StatType.rating,
                  title: 'Рейтинг',
                  value: stats.rating,
                ),
              ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: 'Подписчики',
                  value: stats.subscribersCount,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
