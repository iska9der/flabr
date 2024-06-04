enum SortScore {
  all(label: 'Все', value: ''),
  fromZero(label: '+0', value: '0'),
  fromTen(label: '+10', value: '10'),
  fromTwentyFive(label: '+25', value: '25'),
  fromFifty(label: '+50', value: '50'),
  fromHundred(label: '+100', value: '100');

  const SortScore({required this.label, required this.value});

  final String label;
  final String value;

  static SortScore fromString(String value) => switch (value) {
        '0' => SortScore.fromZero,
        '10' => SortScore.fromTen,
        '25' => SortScore.fromTwentyFive,
        '50' => SortScore.fromFifty,
        '100' => SortScore.fromHundred,
        _ => SortScore.all,
      };
}
