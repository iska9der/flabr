import 'filter_option_model.dart';

abstract class FilterList {
  static const scoreDefault = FilterOption(label: 'Все', value: '');
  static const scoreOptions = [
    FilterOption(label: 'Все', value: ''),
    FilterOption(label: '+0', value: '0'),
    FilterOption(label: '+10', value: '10'),
    FilterOption(label: '+25', value: '25'),
    FilterOption(label: '+50', value: '50'),
    FilterOption(label: '+100', value: '100'),
  ];

  static const dateDefault = FilterOption(label: 'Сутки', value: 'daily');
  static const dateOptions = [
    FilterOption(value: 'daily', label: 'Сутки'),
    FilterOption(value: 'weekly', label: 'Неделя'),
    FilterOption(value: 'monthly', label: 'Месяц'),
    FilterOption(value: 'yearly', label: 'Год'),
    FilterOption(value: 'alltime', label: 'Все время'),
  ];
}
