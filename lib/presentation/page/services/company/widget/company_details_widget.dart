import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/component/router/app_router.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/image_action/image_action.dart';
import '../../../../extension/extension.dart';
import '../../../../widget/detail/section_container_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
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
                  children:
                      card.contacts
                          .map(
                            (contact) => FlabrCard(
                              onTap:
                                  contact.url.isNotEmpty
                                      ? () => getIt<AppRouter>().launchUrl(
                                        contact.url,
                                      )
                                      : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: contact.favicon,
                                    height: 20,
                                    loadingWidget:
                                        (context, url) => const Icon(
                                          Icons.link_outlined,
                                          size: 20,
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Icon(
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
              title: 'Информация',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (card.information.siteUrl.isNotEmpty)
                    ListTile(
                      title: const Text('Сайт'),
                      subtitle: Text(card.information.siteUrl),
                      onTap:
                          () => getIt.get<AppRouter>().launchUrl(
                            card.information.siteUrl,
                          ),
                    ),
                  ListTile(
                    title: const Text('Дата регистрации'),
                    subtitle: Text(
                      DateFormat.yMMMMd().add_jm().format(
                        card.information.registeredAt,
                      ),
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
                      subtitle: Text(card.information.representativeUser.name),
                      onTap:
                          () => context.router.navigate(
                            ServicesFlowRoute(
                              children: [
                                UserDashboardRoute(
                                  alias:
                                      card.information.representativeUser.alias,
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
      },
    );
  }
}
