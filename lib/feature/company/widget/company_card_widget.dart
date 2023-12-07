import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../common/model/hub_type.dart';
import '../../../common/model/render_type.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/feed/card_avatar_widget.dart';
import '../../../common/widget/feed/card_title_widget.dart';
import '../../../common/widget/profile_stat_card_widget.dart';
import '../../../component/router/routes.dart';
import '../../../config/constants.dart';
import '../model/company_model.dart';
import '../model/company_statistics_model.dart';
import '../page/company_list_page.dart';

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.model,
    this.renderType = RenderType.plain,
  });

  final CompanyModel model;
  final RenderType renderType;

  moveToDetails(BuildContext context) {
    context.router.navigateNamed(
      '${ServicesRouterData.routePath}/${CompanyListPage.routePath}/${model.alias}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = model.statistics as CompanyStatisticsModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlabrCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(kBorderRadiusDefault),
                onTap: () => moveToDetails(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardAvatarWidget(
                      imageUrl: model.imageUrl,
                      height: 60,
                    ),
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
              ),
              const SizedBox(height: 20),
              const Text('Пишет в хабы:'),
              Wrap(
                children: model.commonHubs.map((hub) {
                  var title = hub.title;
                  if (hub.isProfiled) {
                    title += '*';
                  }

                  var path = hub.type.isCorporative ? 'companies' : 'hubs';

                  return InkWell(
                    onTap: () => context.navigateNamedTo(
                      'services/$path/${hub.alias}',
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
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
        )
      ],
    );
  }
}
