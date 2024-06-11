import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/component/di/injector.dart';
import '../../../data/model/publication/publication.dart';
import '../../../data/repository/part.dart';
import '../../extension/part.dart';
import '../../page/publications/widget/card/part.dart';
import '../../page/publications/widget/most_reading_widget.dart';
import '../../page/settings/cubit/settings_cubit.dart';
import '../../theme/part.dart';
import '../../utils/utils.dart';
import '../../widget/enhancement/card.dart';
import '../../widget/enhancement/progress_indicator.dart';
import '../../widget/enhancement/responsive_visibility.dart';
import '../auth/cubit/auth_cubit.dart';
import '../scroll/part.dart';

part 'cubit/publication_list_cubit.dart';
part 'widget/publication_list_scaffold.dart';
part 'widget/publication_sliver_list.dart';
