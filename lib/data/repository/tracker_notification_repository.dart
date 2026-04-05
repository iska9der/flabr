import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../model/list_response_model.dart';
import '../model/tracker/tracker.dart';
import '../service/service.dart';

abstract interface class TrackerNotificationRepository {
  Stream<ListResponse<TrackerNotification>> onChange({
    required TrackerNotificationCategory category,
  });

  /// получить список уведомлений по указанной категории
  Future<ListResponse<TrackerNotification>> fetchNotifications({
    String page,
    required TrackerNotificationCategory category,
  });

  /// отметить уведомления как прочитанные
  Future<void> markAsReadNotifications({
    required TrackerNotificationCategory category,
    List<String> ids = const [],
  });
}

@LazySingleton(as: TrackerNotificationRepository)
class TrackerNotificationRepositoryImpl
    implements TrackerNotificationRepository {
  TrackerNotificationRepositoryImpl(this._service);

  final TrackerService _service;

  final Map<
    TrackerNotificationCategory,
    BehaviorSubject<ListResponse<TrackerNotification>>
  >
  _notificationsControllers = {
    for (var category in TrackerNotificationCategory.values)
      category: BehaviorSubject(),
  };

  @override
  Future<ListResponse<TrackerNotification>> fetchNotifications({
    String page = '1',
    required TrackerNotificationCategory category,
  }) async {
    final raw = await _service.fetchNotifications(
      page: page,
      category: category.name,
    );

    final categoryController = _notificationsControllers[category]!;

    if (page == '1') {
      /// при загрузки первой страницы очищаем стрим, чтобы не показывать старые данные
      categoryController.drain();
    }

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    ListResponse<TrackerNotification> response =
        TrackerNotificationListResponse.fromMap(raw);

    /// при загрузки новых данных, объединяем их со старыми, чтобы не терять уже загруженные страницы
    response = (categoryController.valueOrNull ?? const ListResponse()).merge(
      response,
      getId: (ref) => ref.id,
    );

    categoryController.add(response);

    return response;
  }

  @override
  Stream<ListResponse<TrackerNotification>> onChange({
    required TrackerNotificationCategory category,
  }) => _notificationsControllers[category]!.stream;

  @override
  Future<void> markAsReadNotifications({
    required TrackerNotificationCategory category,
    List<String> ids = const [],
  }) async {
    // ignore: unused_local_variable
    final raw = await _service.readNotifications(ids);

    final categoryController = _notificationsControllers[category]!;

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    /// отмечаем уведомления как прочитанные и обновляем стрим
    final last = categoryController.value;
    final newModels = [...last.refs];
    for (int i = 0; i < newModels.length; i++) {
      final model = newModels[i];
      if (ids.contains(model.id)) {
        newModels[i] = model.copyWith(unread: false);
      }
    }
    final result = last.copyWith(refs: newModels);
    categoryController.add(result);
  }
}
