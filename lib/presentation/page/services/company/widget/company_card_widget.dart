import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/router/router.dart';
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
    this.renderType = .plain,
  });

  final Company company;
  final RenderType renderType;

  void moveToDetails(BuildContext context) {
    getIt<AppRouter>().navigate(CompanyDashboardRoute(alias: company.alias));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final baseHubsStyle = theme.textTheme.bodySmall!;
    final hubLinkStyle = baseHubsStyle.copyWith(color: theme.colors.primary);

    final stats = company.statistics;

    return FlabrCard(
      onTap: () => moveToDetails(context),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              CardAvatarWidget(
                imageUrl: company.imageUrl,
                placeholderIcon: AppIcons.companyPlaceholder,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CardTitleWidget(
                      title: company.titleHtml,
                      renderType: renderType,
                    ),
                    if (company.descriptionHtml.isNotEmpty)
                      HtmlWidget(
                        company.descriptionHtml,
                        textStyle: theme.textTheme.labelMedium,
                      ),
                    if (company.commonHubs.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Transform.translate(
                        offset: const Offset(-4, -6),
                        child: Wrap(
                          spacing: 2,
                          crossAxisAlignment: .center,
                          children: [
                            Padding(
                              padding: const .symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Text(
                                'Пишет в хабы:',
                                style: baseHubsStyle,
                              ),
                            ),
                            ...company.commonHubs.map((hub) {
                              var title = hub.title;
                              if (hub.isProfiled) {
                                title += '*';
                              }

                              final route =
                                  switch (hub.type.isCorporative) {
                                        true => CompanyDashboardRoute(
                                          alias: hub.alias,
                                        ),
                                        false => HubDashboardRoute(
                                          alias: hub.alias,
                                        ),
                                      }
                                      as PageRouteInfo;

                              return InkWell(
                                onTap: () => getIt<AppRouter>().navigate(route),
                                borderRadius: AppStyles.cardBorderRadius,
                                child: Padding(
                                  padding: const .symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                  child: Text(title, style: hubLinkStyle),
                                ),
                              );
                            }),
                          ].toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
