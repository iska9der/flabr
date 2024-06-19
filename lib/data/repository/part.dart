import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/component/storage/part.dart';
import '../../core/constants/part.dart';
import '../exception/part.dart';
import '../model/auth_data_model.dart';
import '../model/company/card/company_card_model.dart';
import '../model/filter/part.dart';
import '../model/hub/hub_profile_model.dart';
import '../model/language/part.dart';
import '../model/list_response/comment_list_response.dart';
import '../model/list_response/company_list_response.dart';
import '../model/list_response/hub_list_response.dart';
import '../model/list_response/list_response.dart';
import '../model/list_response/most_reading_response.dart';
import '../model/list_response/publication_list_response.dart';
import '../model/list_response/user_comment_list_response.dart';
import '../model/list_response/user_list_response.dart';
import '../model/publication/publication.dart';
import '../model/publication/publication_counters_model.dart';
import '../model/publication/publication_flow_enum.dart';
import '../model/publication/publication_source_enum.dart';
import '../model/search/search_order.dart';
import '../model/search/search_target.dart';
import '../model/section_enum.dart';
import '../model/summary_model.dart';
import '../model/user/user_bookmarks_type.dart';
import '../model/user/user_model.dart';
import '../model/user/user_publication_type.dart';
import '../model/user/user_whois_model.dart';
import '../model/user_me_model.dart';
import '../service/part.dart';

part 'auth_repository.dart';
part 'company_repository.dart';
part 'hub_repository.dart';
part 'language_repository.dart';
part 'publication_repository.dart';
part 'search_repository.dart';
part 'subscription_repository.dart';
part 'summary_repository.dart';
part 'summary_token_repository.dart';
part 'token_repository.dart';
part 'user_repository.dart';
