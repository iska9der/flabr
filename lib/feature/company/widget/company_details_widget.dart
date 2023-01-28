import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/widget/detail/section_container_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/image/network_image_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../cubit/company_cubit.dart';

class CompanyDetailsWidget extends StatelessWidget {
  const CompanyDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: CircleIndicator.medium(),
          );
        }

        if (state.status.isFailure) {
          return const Center(
            child: Text('Не удалось получить данные о компании'),
          );
        }

        var card = state.card;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.contacts.isNotEmpty)
              SectionContainerWidget(
                title: 'Контакты',
                child: Wrap(
                  spacing: 4,
                  children: card.contacts
                      .map(
                        (contact) => FlabrCard(
                          onTap: contact.url.isNotEmpty
                              ? () => getIt
                                  .get<AppRouter>()
                                  .launchExternalUrl(contact.url)
                              : null,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NetworkImageWidget(
                                imageUrl: contact.favicon,
                                height: 20,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.link_outlined,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(contact.title),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            SectionContainerWidget(
              title: 'Информация',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (card.information.siteUrl.isNotEmpty)
                    ListTile(
                      title: const Text('Сайт'),
                      subtitle: Text(card.information.siteUrl),
                      onTap: () => getIt
                          .get<AppRouter>()
                          .launchExternalUrl(card.information.siteUrl),
                    ),
                  ListTile(
                    title: const Text('Дата регистрации'),
                    subtitle: Text(
                      DateFormat.yMMMMd()
                          .add_jm()
                          .format(card.information.registeredAt),
                    ),
                  ),
                  if (card.information.foundationDate.isNotEmpty)
                    ListTile(
                      title: const Text('Дата основания'),
                      subtitle: Text(card.information.foundedAt),
                    ),
                  if (card.information.staffNumber.isNotEmpty)
                    ListTile(
                      title: const Text('Численность'),
                      subtitle: Text(card.information.staffNumber),
                    ),
                  if (!card.information.representativeUser.isEmpty)
                    ListTile(
                      title: const Text('Представитель'),
                      subtitle: Text(
                        card.information.representativeUser.name,
                      ),
                      onTap: () => context.router.navigateNamed(
                        'services/users/${card.information.representativeUser.alias}',
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
