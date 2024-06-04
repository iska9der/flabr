part of 'company_card_model.dart';

class CompanyCardStatisticsModel extends Equatable {
  const CompanyCardStatisticsModel({
    this.subscribersCount = 0,
    this.rating = 0.0,
    this.invest = 0,
    this.postsCount = 0,
    this.newsCount = 0,
    this.vacanciesCount = 0,
    this.employeesCount = 0,
    this.careerRating = 0.00,
  });

  final int subscribersCount;
  final double rating;
  final int? invest;
  final int postsCount;
  final int newsCount;
  final int vacanciesCount;
  final int employeesCount;
  final double careerRating;

  factory CompanyCardStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CompanyCardStatisticsModel(
      subscribersCount: map['subscribersCount'] as int,
      rating: double.parse(map['rating'].toString()),
      invest: map['invest'] as int? ?? 0,
      postsCount: map['postsCount'] as int? ?? 0,
      newsCount: map['newsCount'] as int? ?? 0,
      vacanciesCount: map['vacanciesCount'] as int? ?? 0,
      employeesCount: map['employeesCount'] as int? ?? 0,
      careerRating: map['careerRating'] as double? ?? 0.00,
    );
  }

  static const CompanyCardStatisticsModel empty = CompanyCardStatisticsModel();
  bool get isEmpty => this == empty;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        subscribersCount,
        rating,
        invest,
        postsCount,
        newsCount,
        vacanciesCount,
        employeesCount,
        careerRating,
      ];
}
