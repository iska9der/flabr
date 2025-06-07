import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../model/list_response_model.dart';
import '../model/tracker/tracker.dart';
import '../service/service.dart';

abstract interface class TrackerRepository {
  Stream<ListResponse<TrackerPublication>> getPublications();

  /// получить список публикаций
  Future<ListResponse<TrackerPublication>> fetchPublications({
    String page,
    bool byAuthor,
  });

  /// отметить публикации как прочитанные
  Future<void> markAsReadPublications(List<String> ids);

  /// отметить публикацию как прочитанную локально
  void readPublication(String id);

  /// удалить публикации из трекера
  Future<void> deletePublications(List<String> ids);

  Stream<ListResponse<TrackerNotification>> getNotifications({
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

@Singleton(as: TrackerRepository)
class TrackerRepositoryImpl implements TrackerRepository {
  TrackerRepositoryImpl(this._service);

  final TrackerService _service;

  final BehaviorSubject<ListResponse<TrackerPublication>>
  _publicationsController = BehaviorSubject();

  final Map<
    TrackerNotificationCategory,
    BehaviorSubject<ListResponse<TrackerNotification>>
  >
  _notificationsControllers = {
    for (var category in TrackerNotificationCategory.values)
      category: BehaviorSubject(),
  };

  @override
  Stream<ListResponse<TrackerPublication>> getPublications() =>
      _publicationsController.asBroadcastStream();

  @override
  Future<ListResponse<TrackerPublication>> fetchPublications({
    String page = '1',
    bool byAuthor = false,
  }) async {
    final map = await _service.fetchPublications(
      page: page,
      byAuthor: byAuthor,
    );

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(map['unreadCounters']);

    ListResponse<TrackerPublication> listResponse =
        TrackerPublicationListResponse.fromMap(map);

    /// сортируем по количеству непрочитанных комментариев
    final sortedRefs = [...listResponse.refs]
      ..sort((a, b) => b.unreadCommentsCount.compareTo(a.unreadCommentsCount));
    listResponse = listResponse.copyWith(refs: sortedRefs);
    _publicationsController.add(listResponse);

    return listResponse;
  }

  @override
  Future<void> markAsReadPublications(List<String> ids) async {
    // ignore: unused_local_variable
    final raw = await _service.readPublications(ids);

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    /// отмечаем публикации как прочитанные и обновляем стрим
    final last = _publicationsController.value;
    final newModels = [...last.refs];
    for (int i = 0; i < newModels.length; i++) {
      final model = newModels[i];
      if (ids.contains(model.id)) {
        newModels[i] = model.copyWith(unreadCommentsCount: 0);
      }
    }
    final result = last.copyWith(refs: newModels);
    _publicationsController.add(result);
  }

  @override
  void readPublication(String id) {
    final last = _publicationsController.value;
    final newModels = [...last.refs];
    final index = newModels.indexWhere((element) => element.id == id);
    newModels[index] = newModels[index].copyWith(unreadCommentsCount: 0);
    final result = last.copyWith(refs: newModels);
    _publicationsController.add(result);
  }

  @override
  Future<void> deletePublications(List<String> ids) async {
    await _service.deletePublications(ids);

    /// удаляем публикации и обновляем стрим
    final last = _publicationsController.value;
    final newModels = [...last.refs];
    newModels.removeWhere((element) => ids.contains(element.id));
    final result = last.copyWith(refs: newModels);
    _publicationsController.add(result);
  }

  @override
  Future<ListResponse<TrackerNotification>> fetchNotifications({
    String page = '1',
    required TrackerNotificationCategory category,
  }) async {
    final raw = await _service.fetchNotifications(
      page: page,
      category: category.name,
    );

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    final listResponse = TrackerNotificationListResponse.fromMap(raw);
    _notificationsControllers[category]!.add(listResponse);

    return listResponse;
  }

  @override
  Stream<ListResponse<TrackerNotification>> getNotifications({
    required TrackerNotificationCategory category,
  }) => _notificationsControllers[category]!.asBroadcastStream();

  @override
  Future<void> markAsReadNotifications({
    required TrackerNotificationCategory category,
    List<String> ids = const [],
  }) async {
    // ignore: unused_local_variable
    final raw = await _service.readNotifications(ids);

    /// TODO: реализовать стрим для счетчиков
    // final unread = TrackerUnreadCounters.fromJson(raw['unreadCounters']);

    /// отмечаем уведомления как прочитанные и обновляем стрим
    final last = _notificationsControllers[category]!.value;
    final newModels = [...last.refs];
    for (int i = 0; i < newModels.length; i++) {
      final model = newModels[i];
      if (ids.contains(model.id)) {
        newModels[i] = model.copyWith(unread: false);
      }
    }
    final result = last.copyWith(refs: newModels);
    _notificationsControllers[category]!.add(result);
  }
}
