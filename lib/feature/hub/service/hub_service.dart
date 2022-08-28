import '../repository/hub_repository.dart';

class HubService {
  const HubService(HubRepository repository) : _repository = repository;

  final HubRepository _repository;

  Future fetchAll() async {}
}
