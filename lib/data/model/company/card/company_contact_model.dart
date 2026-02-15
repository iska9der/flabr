part of 'company_card_model.dart';

class CompanyContact with EquatableMixin {
  const CompanyContact({
    this.title = '',
    this.url = '',
    this.siteTitle = '',
    this.favicon = '',
  });

  final String title;
  final String url;
  final String siteTitle;
  final String favicon;

  factory CompanyContact.fromMap(Map<String, dynamic> map) {
    return CompanyContact(
      title: (map['title'] ?? '') as String,
      url: (map['url'] ?? '') as String,
      siteTitle: (map['siteTitle'] ?? '') as String,
      favicon: (map['favicon'] ?? '') as String,
    );
  }

  @override
  List<Object> get props => [title, url, siteTitle, favicon];
}
