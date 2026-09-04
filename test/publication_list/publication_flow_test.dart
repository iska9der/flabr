import 'package:flabr/data/exception/value_exception.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('flow aliases match Habr routes in menu order', () {
    expect(
      PublicationFlow.values.map((flow) => flow.alias),
      [
        'all',
        'backend',
        'frontend',
        'mobile_development',
        'gamedev',
        'quality_assurance',
        'ai_and_ml',
        'industrial_engineering',
        'admin',
        'information_security',
        'analytics',
        'support',
        'management',
        'top_management',
        'human_resources',
        'design',
        'marketing',
        'hardware_and_gadgets',
        'diy',
        'popsci',
        'healthcare',
      ],
    );
  });

  test('flow aliases are parsed without depending on Dart enum names', () {
    for (final flow in PublicationFlow.values) {
      expect(PublicationFlow.fromString(flow.alias), flow);
    }

    expect(
      () => PublicationFlow.fromString('develop'),
      throwsA(isA<ValueException>()),
    );
  });

  test('flow groups cover every concrete flow in menu order', () {
    expect(
      PublicationFlowGroup.values.expand((group) => group.flows),
      PublicationFlow.values.skip(1),
    );
  });
}
