import 'dart:async';

import '../../data/model/publication/publication.dart';

abstract interface class OfflinePublicationRepository {
  FutureOr<List<Publication>> getAll();

  Stream<List<Publication>> watchAll();

  Future<void> create(Publication publication);

  Future<void> delete(String id);
}
