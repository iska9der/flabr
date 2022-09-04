// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'user_badget_model.dart';

class UserWhoisModel extends Equatable {
  const UserWhoisModel({
    this.badgets = const [],
    this.aboutHtml = '',
    this.contacts = const [],
    this.invitedBy = UserInvitedByModel.empty,
  });

  final List<UserBadgetModel> badgets;
  final String aboutHtml;
  final List contacts;
  final UserInvitedByModel invitedBy;

  UserWhoisModel copyWith({
    List<UserBadgetModel>? badgets,
    String? aboutHtml,
    List? contacts,
    UserInvitedByModel? invitedBy,
  }) {
    return UserWhoisModel(
      badgets: badgets ?? this.badgets,
      aboutHtml: aboutHtml ?? this.aboutHtml,
      contacts: contacts ?? this.contacts,
      invitedBy: invitedBy ?? this.invitedBy,
    );
  }

  factory UserWhoisModel.fromMap(Map<String, dynamic> map) {
    return UserWhoisModel(
      badgets: List<UserBadgetModel>.from(map['badgets'].map(
        (x) => UserBadgetModel.fromMap(x),
      )),
      aboutHtml: map['aboutHtml'] ?? '',
      contacts: map['contacts'] != null ? List.from(map['contacts']) : const [],
      invitedBy: map['invitedBy'] != null
          ? UserInvitedByModel.fromMap(map['invitedBy'])
          : UserInvitedByModel.empty,
    );
  }

  factory UserWhoisModel.fromJson(String source) =>
      UserWhoisModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const UserWhoisModel empty = UserWhoisModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [badgets, aboutHtml, contacts, invitedBy];
}

class UserInvitedByModel extends Equatable {
  /// если поле пустое, значит пользователь зарегался без инвайта
  final String issuerLogin;

  /// дата приглашения
  final String timeCreated;
  DateTime get createdAt => DateTime.parse(timeCreated).toLocal();

  const UserInvitedByModel({
    this.issuerLogin = 'НЛО',
    this.timeCreated = '',
  });

  UserInvitedByModel copyWith({
    String? issuerLogin,
    String? timeCreated,
  }) {
    return UserInvitedByModel(
      issuerLogin: issuerLogin ?? this.issuerLogin,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  factory UserInvitedByModel.fromMap(Map<String, dynamic> map) {
    return UserInvitedByModel(
      issuerLogin: map['issuerLogin'] ?? 'НЛО',
      timeCreated: map['timeCreated'],
    );
  }

  factory UserInvitedByModel.fromJson(String source) =>
      UserInvitedByModel.fromMap(json.decode(source) as Map<String, dynamic>);

  static const UserInvitedByModel empty = UserInvitedByModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [issuerLogin, timeCreated];

  String get fullText {
    return '${DateFormat.yMMMd().format(createdAt)} по приглашению $issuerLogin';
  }
}
