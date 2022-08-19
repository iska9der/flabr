enum SortEnum {
  date,
  rating;

  factory SortEnum.fromString(String value) {
    SortEnum.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение сортировки');
  }
}
