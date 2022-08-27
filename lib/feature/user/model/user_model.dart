import 'package:equatable/equatable.dart';
import 'user_location_model.dart';

import '../../article/model/article_model.dart';
import 'user_workplace_model.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    this.alias = '',
    this.registerDateTime = '',
    this.lastActivityDateTime = '',
    this.avatar = '',
    this.fullName = '',
    this.speciality = '',
    this.score = 0,
    this.rating = 0,
    this.ratingPosition = 0,
    this.location = UserLocationModel.empty,
    this.workplace = const [],
    this.lastPost = ArticleModel.empty,
  });

  final String id;
  final String alias;

  final String registerDateTime;
  DateTime get registeredAt => DateTime.parse(registerDateTime);
  final String lastActivityDateTime;
  DateTime get lastActivityAt => DateTime.parse(lastActivityDateTime);

  final String avatar;
  final String fullName;
  final String speciality;
  final UserLocationModel location;
  final List<UserWorkplaceModel> workplace;
  final ArticleModel lastPost;

  /// "карма" -> очки
  final int score;
  final double rating;
  final int ratingPosition;

  UserModel copyWith({
    String? id,
    String? alias,
    String? registerDateTime,
    String? lastActivityDateTime,
    String? avatar,
    String? fullName,
    String? speciality,
    int? score,
    double? rating,
    int? ratingPosition,
    UserLocationModel? location,
    List<UserWorkplaceModel>? workplace,
    ArticleModel? lastPost,
  }) {
    return UserModel(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      registerDateTime: registerDateTime ?? this.registerDateTime,
      lastActivityDateTime: lastActivityDateTime ?? this.lastActivityDateTime,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      speciality: speciality ?? this.speciality,
      score: score ?? this.score,
      rating: rating ?? this.rating,
      ratingPosition: ratingPosition ?? this.ratingPosition,
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
      avatar: map['avatarUrl'] ?? '',
      fullName: map['fullname'] ?? '',
      speciality: map['speciality'] ?? '',
      score: map['scoreStats']['score'],
      rating:
          map['rating'] != null ? double.parse(map['rating'].toString()) : 0.00,
      ratingPosition:
          map['ratingPos'] != null ? int.parse(map['ratingPos'].toString()) : 0,
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
      avatar,
      fullName,
      speciality,
      score,
      rating,
      ratingPosition,
      location,
      workplace,
      lastPost,
    ];
  }
}
