part of 'company_cubit.dart';

enum CompanyStatus { initial, loading, success, failure }

class CompanyState extends Equatable {
  const CompanyState({
    this.status = CompanyStatus.initial,
    this.error = '',
    required this.alias,
    this.model = CompanyModel.empty,
    this.card = CompanyCardModel.empty,
  });

  final CompanyStatus status;
  final String error;

  final String alias;
  final CompanyModel model;
  final CompanyCardModel card;

  CompanyState copyWith({
    CompanyStatus? status,
    String? error,
    LanguageEnum? langUI,
    List<LanguageEnum>? langArticles,
    CompanyModel? model,
    CompanyCardModel? card,
  }) {
    return CompanyState(
      alias: alias,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      card: card ?? this.card,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        alias,
        model,
        card,
      ];
}
