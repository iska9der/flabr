import 'package:equatable/equatable.dart';

import '../../article/model/article_model.dart';
import 'user_location_model.dart';
import 'user_related_data.dart';
import 'user_workplace_model.dart';

class UserModel extends Equatable {
  const UserModel({
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
    this.location = UserLocationModel.empty,
    this.workplace = const [],
    this.lastPost = ArticleModel.empty,
  });

  final String id;
  final String alias;

  final String registerDateTime;
  DateTime get registeredAt => DateTime.parse(registerDateTime).toLocal();
  final String lastActivityDateTime;
  DateTime get lastActivityAt => DateTime.parse(lastActivityDateTime).toLocal();

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
  final UserLocationModel location;
  final List<UserWorkplaceModel> workplace;
  final ArticleModel lastPost;

  UserModel copyWith({
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
    UserLocationModel? location,
    List<UserWorkplaceModel>? workplace,
    ArticleModel? lastPost,
  }) {
    return UserModel(
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
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
      relatedData: map['relatedData'] != null
          ? UserRelatedData.fromMap(map['relatedData'])
          : UserRelatedData.empty,
      location: map['location'] != null
          ? UserLocationModel.fromMap(map['location'])
          : UserLocationModel.empty,
      workplace: map['workplace'] != null
          ? List<UserWorkplaceModel>.from(
              map['workplace'].map((e) => UserWorkplaceModel.fromMap(e)),
            )
          : const [],
      lastPost: map['lastPost'] != null
          ? ArticleModel.fromMap(map['lastPost'])
          : ArticleModel.empty,
    );
  }

  static const UserModel empty = UserModel(id: '0');
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
