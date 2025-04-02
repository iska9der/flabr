import 'package:equatable/equatable.dart';

class SummaryModel extends Equatable {
  const SummaryModel({
    this.title = '',
    this.sharingUrl = '',
    this.content = const [],
  });

  final String title;
  final String sharingUrl;
  final List<String> content;

  SummaryModel copyWith({
    String? title,
    String? sharingUrl,
    List<String>? content,
  }) {
    return SummaryModel(
      title: title ?? this.title,
      sharingUrl: sharingUrl ?? this.sharingUrl,
      content: content ?? this.content,
    );
  }

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    final thesis = List.from(map['thesis'] ?? []);
    final parsedContent =
        List<String>.from(thesis.map((t) => t['content'])).toList();

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
