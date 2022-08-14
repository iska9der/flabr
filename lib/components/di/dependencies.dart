import 'package:flabr/components/router/router.gr.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setDependencies() {
  getIt.registerSingleton<AppRouter>(AppRouter());
}
