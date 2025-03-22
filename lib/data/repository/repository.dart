import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../core/component/storage/storage.dart';
import '../../core/constants/constants.dart';
import '../exception/exception.dart';
import '../model/comment/comment.dart';
import '../model/company/company.dart';
import '../model/filter/filter.dart';
import '../model/hub/hub.dart';
import '../model/language/language.dart';
import '../model/list_response/user_comment_list_response.dart';
import '../model/list_response/user_list_response.dart';
import '../model/list_response_model.dart';
import '../model/publication/publication.dart';
import '../model/search/search_order_enum.dart';
import '../model/search/search_target_enum.dart';
import '../model/section_enum.dart';
import '../model/tokens_model.dart';
import '../model/tracker/tracker.dart';
import '../model/user/user.dart';
import '../service/service.dart';

part 'auth_repository.dart';
part 'company_repository.dart';
part 'hub_repository.dart';
part 'language_repository.dart';
part 'publication_repository.dart';
part 'publication_vote_repository.dart';
part 'search_repository.dart';
part 'subscription_repository.dart';
part 'summary_repository.dart';
part 'summary_token_repository.dart';
part 'token_repository.dart';
part 'tracker_repository.dart';
part 'user_repository.dart';
