import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthDataModel extends Equatable {
  const AuthDataModel({
    this.connectSID = '',
    this.habrSID = '',
    this.accCSID = '',
    this.phpSID = '',
    this.hSecID = '',
  });

  final String connectSID;
  final String habrSID;
  final String accCSID;
  final String phpSID;
  final String hSecID;

  @override
  List<Object> get props => [
        connectSID,
        habrSID,
        accCSID,
        phpSID,
        hSecID,
      ];

  static const empty = AuthDataModel();
  bool get isEmpty => this == empty;

  Map<String, dynamic> toMap() {
    return {
      'connectSID': connectSID,
      'habrSessionID': habrSID,
      'acc_csid': accCSID,
      'PHPSESSID': phpSID,
      'hsec_id': hSecID,
    };
  }

  factory AuthDataModel.fromMap(Map<String, dynamic> map) {
    return AuthDataModel(
      connectSID: map['connectSID'] as String,
      habrSID: map['habrSessionID'] as String,
      accCSID: map['acc_csid'] as String,
      phpSID: map['PHPSESSID'] as String,
      hSecID: map['hsec_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthDataModel.fromJson(String source) => AuthDataModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  String toCookieString() {
    return 'connect_sid="$connectSID"; habrsession_id="$habrSID"; fl=ru; hl=ru; acc_csid="$accCSID"; habr_web_redirect_back=%2Fru%2Fall%2F; PHPSESSID="$phpSID"; hsec_id="$hSecID"';
  }
}
