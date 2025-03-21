part of 'service.dart';

@LazySingleton(as: SummaryService)
class SummaryServiceApp extends SummaryServiceImpl {
  const SummaryServiceApp(super._client);
}
