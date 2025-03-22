import 'package:equatable/equatable.dart';

import '../publication/publication_model.dart';
import '../related_data/user_related_data_model.dart';
import 'user_location_model.dart';
import 'user_workplace_model.dart';

class User extends Equatable {
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
    this.relatedData = UserRelatedData.empty,
    this.location = UserLocation.empty,
    this.workplace = const [],
    this.lastPost = PublicationCommon.empty,
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

  /// количество голосов
  final int votesCount;

  /// рейтинг
  final double rating;

  /// позиция в рейтинге
  final int ratingPosition;

  final UserRelatedData relatedData;
  final UserLocation location;
  final List<UserWorkplace> workplace;
  final PublicationCommon lastPost;

  User copyWith({
    String? id,
    String? alias,
    String? registerDateTime,
    String? lastActivityDateTime,
    String? avatarUrl,
    String? fullname,
    String? speciality,
    int? score,
    int? votesCount,
    double? rating,
    int? ratingPosition,
    UserRelatedData? relatedData,
    UserLocation? location,
    List<UserWorkplace>? workplace,
    PublicationCommon? lastPost,
  }) {
    return User(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      registerDateTime: registerDateTime ?? this.registerDateTime,
      lastActivityDateTime: lastActivityDateTime ?? this.lastActivityDateTime,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullname: fullname ?? this.fullname,
      speciality: speciality ?? this.speciality,
      score: score ?? this.score,
      votesCount: votesCount ?? this.votesCount,
      rating: rating ?? this.rating,
      ratingPosition: ratingPosition ?? this.ratingPosition,
      relatedData: relatedData ?? this.relatedData,
      location: location ?? this.location,
      workplace: workplace ?? this.workplace,
      lastPost: lastPost ?? this.lastPost,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
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
      rating:
          map['rating'] != null ? double.parse(map['rating'].toString()) : 0.00,
      ratingPosition:
          map['ratingPos'] != null ? int.parse(map['ratingPos'].toString()) : 0,
      relatedData:
          map['relatedData'] != null
              ? UserRelatedData.fromMap(map['relatedData'])
              : UserRelatedData.empty,
      location:
          map['location'] != null
              ? UserLocation.fromMap(map['location'])
              : UserLocation.empty,
      workplace:
          map['workplace'] != null
              ? List<UserWorkplace>.from(
                map['workplace'].map((e) => UserWorkplace.fromMap(e)),
              )
              : const [],
      lastPost:
          map['lastPost'] != null
              ? PublicationCommon.fromMap(map['lastPost'])
              : PublicationCommon.empty,
    );
  }

  static const User empty = User(id: '0');
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
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
      relatedData,
      location,
      workplace,
      lastPost,
    ];
  }
}
