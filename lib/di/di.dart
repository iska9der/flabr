import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../core/component/logger/logger.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
)
Future<void> configureDependencies({
  String? env,
  required Logger logger,
}) async {
  getIt.registerSingleton<Logger>(logger);

  await getIt.$initGetIt(environment: env);

  await getIt.allReady();
}
