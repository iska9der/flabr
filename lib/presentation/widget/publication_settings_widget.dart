import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../../i18n/i18n.dart';
import '../page/settings/widget/settings_card_widget.dart';
import '../page/settings/widget/settings_checkbox_widget.dart';

class PublicationSettingsWidget extends StatelessWidget {
  const PublicationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: 4,
      children: [
        SettingsCardWidget(
          title: context.t.settings.publication.visibility.title,
          icon: Icons.visibility_outlined,
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.publication.isImagesVisible !=
                    current.publication.isImagesVisible,
                builder: (context, state) {
                  return SettingsCheckboxWidget(
                    initialValue: state.publication.isImagesVisible,
                    icon: Icons.image_outlined,
                    title: Text(
                      context.t.settings.publication.visibility.images,
                    ),
                    onChanged: (bool value) => context
                        .read<SettingsCubit>()
                        .changeArticleImageVisibility(isVisible: value),
                  );
                },
              ),
              const Divider(height: 1),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.publication.webViewEnabled !=
                    current.publication.webViewEnabled,
                builder: (context, state) {
                  return SettingsCheckboxWidget(
                    initialValue: state.publication.webViewEnabled,
                    title: Text(
                      context.t.settings.publication.visibility.webView,
                    ),
                    onChanged: (bool value) => context
                        .read<SettingsCubit>()
                        .changeWebViewVisibility(isVisible: value),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
