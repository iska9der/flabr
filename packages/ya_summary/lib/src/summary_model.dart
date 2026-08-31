import 'package:equatable/equatable.dart';

class SummaryModel with Equatable {
  const SummaryModel({
    this.title = '',
    this.sharingUrl = '',
    this.content = const [],
  });

  final String title;
  final String sharingUrl;
  final List<String> content;

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    final thesisList = List<Map<String, dynamic>>.from(map['thesis'] ?? []);
    final parsedContent = thesisList
        .map((thesis) => thesis['content'] as String)
        .toList();

    return SummaryModel(
      title: (map['title'] ?? '') as String,
      sharingUrl: (map['sharing_url'] ?? '') as String,
      content: parsedContent,
    );
  }

  static const empty = SummaryModel();

  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [title, sharingUrl, content];
}
