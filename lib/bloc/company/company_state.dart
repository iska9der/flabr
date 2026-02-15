part of 'company_cubit.dart';

enum CompanyStatus { initial, loading, success, failure }

class CompanyState with EquatableMixin {
  const CompanyState({
    this.status = CompanyStatus.initial,
    this.error = '',
    required this.alias,
    this.model = Company.empty,
    this.card = CompanyCard.empty,
  });

  final CompanyStatus status;
  final String error;

  final String alias;
  final Company model;
  final CompanyCard card;

  CompanyState copyWith({
    CompanyStatus? status,
    String? error,
    Language? langUI,
    List<Language>? langArticles,
    Company? model,
    CompanyCard? card,
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
