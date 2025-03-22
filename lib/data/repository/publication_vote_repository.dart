import 'dart:async';

import 'package:injectable/injectable.dart';

import '../model/publication/publication.dart';
import '../service/service.dart';

abstract class PublicationVoteRepository {
  Future<PublicationVoteResponse> voteUp(String publicationId);

  Future<PublicationVoteResponse> voteDown(String publicationId);
}

@prod
@LazySingleton(as: PublicationVoteRepository)
class PublicationVoteRepositoryApi implements PublicationVoteRepository {
  PublicationVoteRepositoryApi(this.service);

  final PublicationService service;

  @override
  Future<PublicationVoteResponse> voteUp(String publicationId) async {
    return await service.voteUp(publicationId);
  }

  @override
  Future<PublicationVoteResponse> voteDown(String publicationId) async {
    return await service.voteDown(publicationId);
  }
}

@test
@LazySingleton(as: PublicationVoteRepository)
class PublicationVoteRepositoryTest implements PublicationVoteRepository {
  @override
  Future<PublicationVoteResponse> voteUp(String publicationId) async {
    await Future.delayed(const Duration(seconds: 1));

    return PublicationVoteResponse(
      score: 15,
      votesCount: 10,
      vote: PublicationVote(value: 1),
    );
  }

  @override
  Future<PublicationVoteResponse> voteDown(String publicationId) async {
    await Future.delayed(const Duration(seconds: 1));

    return PublicationVoteResponse(
      score: 14,
      votesCount: 10,
      vote: PublicationVote(value: -1),
    );
  }
}
