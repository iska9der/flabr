import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../core/component/http/http.dart';
import '../exception/exception.dart';
import '../model/comment/comment.dart';
import '../model/company/company.dart';
import '../model/filter/filter.dart';
import '../model/hub/hub.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/query_params_model.dart';
import '../model/search/search.dart';
import '../model/section_enum.dart';
import '../model/tracker/tracker.dart';
import '../model/user/user.dart';

part 'auth_service.dart';
part 'company_service.dart';
part 'hub_service.dart';
part 'publication_service.dart';
part 'search_service.dart';
part 'summary_service.dart';
part 'tracker_service.dart';
part 'user_service.dart';
