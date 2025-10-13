import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/company/company.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.company,
    this.renderType = RenderType.plain,
  });

  final Company company;
  final RenderType renderType;

  void moveToDetails(BuildContext context) {
    getIt<AppRouter>().navigate(CompanyDashboardRoute(alias: company.alias));
  }

  @override
  Widget build(BuildContext context) {
    final stats = company.statistics as CompanyStatistics;
    final hubLinkStyle = context.theme.textTheme.bodySmall?.copyWith(
      color: context.theme.colors.primary,
    );

    return FlabrCard(
      onTap: () => moveToDetails(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardAvatarWidget(
                imageUrl: company.imageUrl,
                placeholderIcon: AppIcons.companyPlaceholder,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardTitleWidget(
                      title: company.titleHtml,
                      renderType: renderType,
                    ),
                    if (company.descriptionHtml.isNotEmpty)
                      HtmlWidget(
                        company.descriptionHtml,
                        textStyle: context.theme.textTheme.labelMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (company.commonHubs.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Пишет в хабы:'),
            Wrap(
              spacing: 14,
              children:
                  company.commonHubs.map((hub) {
                    var title = hub.title;
                    if (hub.isProfiled) {
                      title += '*';
                    }

                    final route =
                        switch (hub.type.isCorporative) {
                              true => CompanyDashboardRoute(
                                alias: hub.alias,
                              ),
                              false => HubDashboardRoute(alias: hub.alias),
                            }
                            as PageRouteInfo;

                    return InkWell(
                      onTap: () => getIt<AppRouter>().navigate(route),
                      borderRadius: AppStyles.cardBorderRadius,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(title, style: hubLinkStyle),
                      ),
                    );
                  }).toList(),
            ),
          ],
          const SizedBox(height: 10),
          Row(
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
        ],
      ),
    );
  }
}
