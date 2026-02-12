part of 'publication.dart';

/// Типы меток для постов
enum PostLabelType {
  translation,
  recovery,
  sandbox,
  unknown;

  /// Парсер типа метки из строки
  static PostLabelType fromString(String? type) {
    return switch (type?.toLowerCase()) {
      'translation' => PostLabelType.translation,
      'recovery' => PostLabelType.recovery,
      'sandbox' => PostLabelType.sandbox,
      _ => PostLabelType.unknown,
    };
  }
}
