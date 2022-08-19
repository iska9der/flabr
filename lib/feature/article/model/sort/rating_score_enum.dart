enum RatingScoreEnum {
  all('Все', ''),
  fromZero('+0', '0'),
  fromTen('+10', '10'),
  fromTwentyFive('+25', '25'),
  fromFifty('+50', '50'),
  fromHundred('+100', '100');

  const RatingScoreEnum(this.label, this.value);

  final String label;
  final String value;
}
