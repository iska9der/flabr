import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../data/model/user/user_badget_model.dart';
import '../../../../widget/detail/section_container_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/html_view_widget.dart';
import '../cubit/user_cubit.dart';

class UserWhoisWidget extends StatelessWidget {
  const UserWhoisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>().fetchWhois();

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => !current.whoisModel.isEmpty,
      builder: (context, state) {
        var model = state.whoisModel;

        return Column(
          children: [
            if (model.badgets.isNotEmpty)
              SectionContainerWidget(
                title: 'Значки',
                child: _BadgetsWidget(badgets: model.badgets),
              ),
            if (!model.invitedBy.isEmpty)
              SectionContainerWidget(
                title: 'Приглашен',
                child: Text(model.invitedBy.fullText),
              ),
            if (model.aboutHtml.isNotEmpty)
              SectionContainerWidget(
                title: 'О себе',
                child: HtmlView(
                  textHtml: model.aboutHtml,
                  renderMode: RenderMode.column,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BadgetsWidget extends StatelessWidget {
  const _BadgetsWidget({required this.badgets});

  final List<UserBadget> badgets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Scrollbar(
        thumbVisibility: false,
        thickness: 1,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: badgets
              .map((badge) => Align(
                    alignment: Alignment.topCenter,
                    child: Tooltip(
                      message: badge.description,
                      triggerMode: TooltipTriggerMode.tap,
                      child: FlabrCard(
                        child: Text(badge.title),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
