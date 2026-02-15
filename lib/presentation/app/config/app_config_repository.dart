part of 'config.dart';

@Singleton()
class AppConfigRepository {
  AppConfigRepository();

  final BehaviorSubject<bool> _initCtrl = .seeded(false);

  Stream<bool> get onInitialized => _initCtrl.asBroadcastStream();

  bool get isInitialized => _initCtrl.valueOrNull ?? false;

  void setInitialized() {
    _initCtrl.add(true);
  }
}
