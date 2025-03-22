import 'package:injectable/injectable.dart';
import 'package:ya_summary/ya_summary.dart';

@LazySingleton(as: SummaryService)
class SummaryServiceApp extends SummaryServiceImpl {
  const SummaryServiceApp(super._client);
}
