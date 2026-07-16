import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';
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
                    title: const Text('Изображения'),
                    onChanged: (bool value) => context
                        .read<SettingsCubit>()
                        .changeArticleImageVisibility(isVisible: value),
                  );
                },
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.publication.webViewEnabled !=
                    current.publication.webViewEnabled,
                builder: (context, state) {
                  return SettingsCheckboxWidget(
                    initialValue: state.publication.webViewEnabled,
                    title: const Text('WebView'),
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
