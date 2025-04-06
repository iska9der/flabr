// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Tokens extends Equatable {
  const Tokens({
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
  List<Object> get props => [connectSID, habrSID, accCSID, phpSID, hSecID];

  static const empty = Tokens();
  bool get isEmpty => this == empty;
  bool get isNotEmpty => !isEmpty;

  Map<String, dynamic> toMap() {
    return {
      'connect_sid': connectSID,
      'habrsession_id': habrSID,
      'acc_csid': accCSID,
      'PHPSESSID': phpSID,
      'hsec_id': hSecID,
    };
  }

  factory Tokens.fromMap(Map<String, dynamic> map) {
    return Tokens(
      connectSID: map['connectSID'] ?? map['connect_sid'] ?? '',
      habrSID: map['habrSessionID'] ?? map['habrsession_id'] ?? '',
      accCSID: map['acc_csid'] ?? '',
      phpSID: map['PHPSESSID'] ?? '',
      hSecID: map['hsec_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tokens.fromJson(String source) =>
      Tokens.fromMap(json.decode(source) as Map<String, dynamic>);

  String toCookieString() {
    return toMap().entries
        .where((entry) => entry.value.isNotEmpty)
        .map((e) => '${e.key}=${e.value}')
        .join('; ');
  }
}
