import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../publication/publication.dart';
import 'user_location_model.dart';
import 'user_related_data_model.dart';
import 'user_workplace_model.dart';

class User with Equatable {
  const User({
    required this.id,
    this.alias = '',
    this.registerDateTime = '',
    this.lastActivityDateTime = '',
    this.avatarUrl = '',
    this.fullname = '',
    this.speciality = '',
    this.score = 0,
    this.votesCount = 0,
    this.rating = 0,
    this.ratingPosition = 0,
    this.reach,
    this.relatedData = UserRelatedData.empty,
    this.location = UserLocation.empty,
    this.workplace = const [],
    this.lastPost = Publication.empty,
  });

  final String id;
  final String alias;

  final String registerDateTime;
  DateTime? get registeredAt => DateTime.tryParse(registerDateTime)?.toLocal();

  final String lastActivityDateTime;
  DateTime? get lastActivityAt =>
      DateTime.tryParse(lastActivityDateTime)?.toLocal();

  final String avatarUrl;
  final String fullname;
  final String speciality;

  /// "карма" -> очки
  final int score;

  /// Количество голосов
  final int votesCount;

  /// Рейтинг
  final double rating;

  /// Позиция в рейтинге
  final int ratingPosition;

  /// Охват за 30 дней
  final String? reach;

  final UserRelatedData relatedData;
  final UserLocation location;
  final List<UserWorkplace> workplace;
  final PublicationCommon lastPost;

  factory User.fromMap(Map<String, dynamic> map) {
    final workplacesList = List<Map<String, dynamic>>.from(
      map['workplace'] ?? [],
    );

    return User(
      id: map['id'] ?? '',
      alias: map['alias'],
      registerDateTime: map['registerDateTime'] ?? '',
      lastActivityDateTime: map['lastActivityDateTime'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      fullname: map['fullname'] ?? '',
      speciality: map['speciality'] ?? '',
      score: map['scoreStats']['score'],
      votesCount: map['scoreStats']['votesCount'],
      rating: map['rating'] != null
          ? double.parse(map['rating'].toString())
          : 0.0,
      ratingPosition: map['ratingPos'] != null
          ? int.parse(map['ratingPos'].toString())
          : 0,
      reach: map['reach'] as String?,
      relatedData: map['relatedData'] != null
          ? UserRelatedData.fromJson(map['relatedData'])
          : UserRelatedData.empty,
      location: map['location'] != null
          ? UserLocation.fromMap(map['location'])
          : UserLocation.empty,
      workplace: UnmodifiableListView(
        workplacesList.map((e) => UserWorkplace.fromMap(e)),
      ),
      lastPost: map['lastPost'] != null
          ? PublicationCommon.fromJson(map['lastPost'])
          : Publication.empty,
    );
  }

  static const User empty = User(id: '0');
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      alias,
      registerDateTime,
      lastActivityDateTime,
      avatarUrl,
      fullname,
      speciality,
      score,
      votesCount,
      rating,
      ratingPosition,
      reach,
      relatedData,
      location,
      workplace,
      lastPost,
    ];
  }
}
