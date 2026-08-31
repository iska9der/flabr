import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/component/router/router.dart';
import '../../../../../data/model/company/company.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/image_action/image_action.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../widget/detail/section_container_widget.dart';
import '../../../../widget/enhancement/card.dart';

class CompanyDetailsWidget extends StatelessWidget {
  const CompanyDetailsWidget({super.key, required this.card});

  final CompanyCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (card.contacts.isNotEmpty)
          SectionContainerWidget(
            title: context.t.company.contacts,
            child: Wrap(
              spacing: 4,
              children: card.contacts
                  .map(
                    (contact) => FlabrCard(
                      onTap: contact.url.isNotEmpty
                          ? () => getIt<AppRouter>().launchUrl(contact.url)
                          : null,
                      child: Row(
                        mainAxisSize: .min,
                        spacing: 10,
                        children: [
                          NetworkImageWidget(
                            imageUrl: contact.favicon,
                            height: 20,
                            loadingPlaceholder: const Icon(
                              Icons.link_outlined,
                              size: 20,
                            ),
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.link_outlined,
                              size: 20,
                            ),
                          ),
                          Text(contact.title),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        SectionContainerWidget(
          title: context.t.company.information,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              if (card.information.siteUrl.isNotEmpty)
                ListTile(
                  title: Text(context.t.company.website),
                  subtitle: Text(card.information.siteUrl),
                  onTap: () => getIt.get<AppRouter>().launchUrl(
                    card.information.siteUrl,
                  ),
                ),
              ListTile(
                title: Text(context.t.company.registrationDate),
                subtitle: Text(
                  DateFormat.yMMMMd().add_jm().format(
                    card.information.registeredAt,
                  ),
                ),
              ),
              if (card.information.foundationDate.isNotEmpty)
                ListTile(
                  title: Text(context.t.company.foundedDate),
                  subtitle: Text(card.information.foundedAt),
                ),
              if (card.information.staffNumber.isNotEmpty)
                ListTile(
                  title: Text(context.t.company.size),
                  subtitle: Text(card.information.staffNumber),
                ),
              if (!card.information.representativeUser.isEmpty)
                ListTile(
                  title: Text(context.t.company.representative),
                  subtitle: Text(card.information.representativeUser.name),
                  onTap: () => context.router.navigate(
                    ServicesFlowRoute(
                      children: [
                        UserDashboardRoute(
                          alias: card.information.representativeUser.alias,
                          children: [UserDetailRoute()],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
