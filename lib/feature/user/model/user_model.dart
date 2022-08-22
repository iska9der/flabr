// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

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
  });

  final String id;
  final String alias;
  final String timeRegistered;
  final String avatar;
  final String fullName;
  final String speciality;

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
    ];
  }
}
