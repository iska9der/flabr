enum ScoreEnum {
  all(label: 'Все', value: ''),
  fromZero(label: '+0', value: '0'),
  fromTen(label: '+10', value: '10'),
  fromTwentyFive(label: '+25', value: '25'),
  fromFifty(label: '+50', value: '50'),
  fromHundred(label: '+100', value: '100');

  const ScoreEnum({required this.label, required this.value});

  final String label;
  final String value;

  static ScoreEnum fromString(String value) => switch (value) {
        '0' => ScoreEnum.fromZero,
        '10' => ScoreEnum.fromTen,
        '25' => ScoreEnum.fromTwentyFive,
        '50' => ScoreEnum.fromFifty,
        '100' => ScoreEnum.fromHundred,
        _ => ScoreEnum.all,
      };
}
