import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../core/component/router/router.dart';
import '../../../di/di.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/page/publications/publication_detail_page.dart';
import '../../../presentation/page/publications/widget/stats/stats.dart';
import '../../../presentation/theme/theme.dart';
import '../../../presentation/widget/enhancement/app_expansion_panel.dart';
import '../../../presentation/widget/enhancement/card.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../cubit/most_reading_cubit.dart';

part 'most_reading_button.dart';
part 'most_reading_list_view.dart';

class MostReadingWidget extends StatelessWidget {
  const MostReadingWidget({super.key}) : isButton = false;
  const MostReadingWidget.button({super.key}) : isButton = true;

  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return isButton ? const _Button() : const _ListView();
  }
}
