import 'package:equatable/equatable.dart';

class UserLocationModel extends Equatable {
  final String country;
  final String region;
  final String city;
  const UserLocationModel({
    required this.country,
    required this.region,
    required this.city,
  });

  UserLocationModel copyWith({
    String? country,
    String? region,
    String? city,
  }) {
    return UserLocationModel(
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
    );
  }

  factory UserLocationModel.fromMap(Map<String, dynamic> map) {
    return UserLocationModel(
      country: map['country'] != null ? map['country']['title'] : '',
      region: map['region'] != null ? map['region']['title'] : '',
      city: map['city'] != null ? map['city']['title'] : '',
    );
  }

  static const empty = UserLocationModel(country: '', region: '', city: '');
  bool get isEmpty => this == empty;

  String get fullLocation {
    return country +
        (region.isNotEmpty ? ', $region' : '') +
        (city.isNotEmpty ? ', $city' : '');
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [country, region, city];
}
