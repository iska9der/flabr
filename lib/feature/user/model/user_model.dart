import 'package:equatable/equatable.dart';

import '../../article/model/article_model.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    this.alias = '',
    this.timeRegistered = '',
    this.avatar = '',
    this.fullName = '',
    this.speciality = '',
    this.score = 0,
    this.rating = 0,
    this.ratingPosition = 0,
    this.lastPost = ArticleModel.empty,
  });

  final String id;
  final String alias;
  final String timeRegistered;
  final String avatar;
  final String fullName;
  final String speciality;
  final ArticleModel lastPost;

  /// "карма" -> очки
  final int score;
  final double rating;
  final int ratingPosition;

  UserModel copyWith({
    String? id,
    String? alias,
    String? timeRegistered,
    String? avatar,
    String? fullName,
    String? speciality,
    int? score,
    double? rating,
    int? ratingPosition,
    ArticleModel? lastPost,
  }) {
    return UserModel(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      timeRegistered: timeRegistered ?? this.timeRegistered,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      speciality: speciality ?? this.speciality,
      score: score ?? this.score,
      rating: rating ?? this.rating,
      ratingPosition: ratingPosition ?? this.ratingPosition,
      lastPost: lastPost ?? this.lastPost,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      alias: map['alias'],
      timeRegistered: map['registerDateTime'] ?? '',
      avatar: map['avatarUrl'] ?? '',
      fullName: map['fullname'] ?? '',
      speciality: map['speciality'] ?? '',
      score: map['scoreStats']['score'],
      rating:
          map['rating'] != null ? double.parse(map['rating'].toString()) : 0.00,
      ratingPosition:
          map['ratingPos'] != null ? int.parse(map['ratingPos'].toString()) : 1,
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
      timeRegistered,
      avatar,
      fullName,
      speciality,
      score,
      rating,
      ratingPosition,
      lastPost,
    ];
  }
}
