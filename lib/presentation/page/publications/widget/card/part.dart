import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/publication/publication_author_model.dart';
import '../../../../../data/model/publication/publication_format_enum.dart';
import '../../../../../data/model/publication/publication_hub_model.dart';
import '../../../../../data/model/publication/publication_type_enum.dart';
import '../../../../../data/model/related_data/hub_related_data_model.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../data/model/stat_type_enum.dart';
import '../../../../extension/part.dart';
import '../../../../feature/auth/cubit/auth_cubit.dart';
import '../../../../feature/auth/widget/dialog.dart';
import '../../../../feature/image_action/part.dart';
import '../../../../feature/summary/cubit/summary_auth_cubit.dart';
import '../../../../feature/summary/widget/summary_dialog.dart';
import '../../../../theme/part.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/author_widget.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../articles/article_comment_page.dart';
import '../../cubit/publication_bookmark_cubit.dart';
import '../../posts/post_comment_page.dart';
import '../stats/part.dart';

part 'common_card_widget.dart';
part 'components/footer_widget.dart';
part 'components/format_widget.dart';
part 'components/header_widget.dart';
part 'components/hubs_widget.dart';
part 'components/publication_type_widget.dart';
part 'post_card_widget.dart';
part 'publication_card_widget.dart';
part 'skeleton_card_widget.dart';