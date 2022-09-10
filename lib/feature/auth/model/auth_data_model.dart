import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthDataModel extends Equatable {
  const AuthDataModel({
    this.connectSId = '',
    this.habrSessionId = '',
    this.accCsId = '',
    this.phpSessId = '',
    this.hcSecId = '',
  });

  final String connectSId;
  final String habrSessionId;
  final String accCsId;
  final String phpSessId;
  final String hcSecId;

  @override
  List<Object> get props => [
        connectSId,
        habrSessionId,
        accCsId,
        phpSessId,
        hcSecId,
      ];

  static const empty = AuthDataModel();
  bool get isEmpty => this == empty;

  Map<String, dynamic> toMap() {
    return {
      'connectSID': connectSId,
      'habrSessionID': habrSessionId,
      'acc_csid': accCsId,
      'PHPSESSID': phpSessId,
      'hsec_id': hcSecId,
    };
  }

  factory AuthDataModel.fromMap(Map<String, dynamic> map) {
    return AuthDataModel(
      connectSId: map['connectSID'] as String,
      habrSessionId: map['habrSessionID'] as String,
      accCsId: map['acc_csid'] as String,
      phpSessId: map['PHPSESSID'] as String,
      hcSecId: map['hsec_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthDataModel.fromJson(String source) => AuthDataModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
