import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/router/router.dart';
import '../../../../../data/model/company/company.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/card_avatar_widget.dart';
import '../../../../widget/card_title_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/profile_stat_card_widget.dart';

class CompanyListCardWidget extends StatelessWidget {
  const CompanyListCardWidget({
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
                    if (company.descriptionHtml.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      HtmlWidget(
                        company.descriptionHtml,
                        textStyle: theme.textTheme.labelMedium,
                      ),
                    ],
                    if (company.commonHubs.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _CompanyHubs(hubs: company.commonHubs),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ProfileStatCardWidget(
                  title: context.t.company.rating,
                  value: stats.rating.toString(),
                  valueColor: StatType.rating.getColorByScore(
                    stats.rating,
                    theme.colors,
                  ),
                ),
              ),
              Expanded(
                child: ProfileStatCardWidget(
                  title: context.t.company.followers,
                  value: stats.subscribersCount.compact(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompanyHubs extends StatefulWidget {
  const _CompanyHubs({required this.hubs});

  final List<CompanyHub> hubs;

  @override
  State<_CompanyHubs> createState() => _CompanyHubsState();
}

class _CompanyHubsState extends State<_CompanyHubs> {
  bool isExpanded = false;

  void toggle() {
    setState(() => isExpanded = !isExpanded);
  }

  PageRouteInfo routeFor(CompanyHub hub) => switch (hub.type.isCorporative) {
    true => CompanyDashboardRoute(alias: hub.alias),
    false => HubDashboardRoute(alias: hub.alias),
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textStyle = theme.textTheme.bodySmall!;
    final linkStyle = textStyle.copyWith(color: theme.colors.primary);

    return Column(
      crossAxisAlignment: .start,
      children: [
        InkWell(
          onTap: toggle,
          borderRadius: AppRadius.sm,
          child: Padding(
            padding: const .symmetric(vertical: 4),
            child: Row(
              mainAxisSize: .min,
              children: [
                Flexible(
                  child: Text(
                    context.t.company.postsInHubs,
                    style: textStyle,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: isExpanded ? .5 : 0,
                  duration: AppDuration.hide,
                  child: Icon(
                    AppIcons.chevronDown,
                    size: 18,
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: AppDuration.hide,
          curve: Curves.easeOut,
          alignment: .topCenter,
          child: isExpanded
              ? Padding(
                  padding: const .only(top: 2),
                  child: Wrap(
                    spacing: 2,
                    children: [
                      for (final hub in widget.hubs)
                        InkWell(
                          onTap: () => getIt<AppRouter>().navigate(
                            routeFor(hub),
                          ),
                          borderRadius: AppRadius.sm,
                          child: Padding(
                            padding: const .symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: Text(
                              hub.isProfiled ? '${hub.title}*' : hub.title,
                              style: linkStyle,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
