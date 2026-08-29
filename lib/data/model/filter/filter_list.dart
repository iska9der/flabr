import '../../../i18n/i18n.dart';
import 'filter_option_model.dart';

abstract class FilterList {
  static const scoreDefault = FilterOption(label: '', value: '');
  static List<FilterOption> get scoreOptions => [
    FilterOption(label: t.filter.all, value: ''),
    const FilterOption(label: '+0', value: '0'),
    const FilterOption(label: '+10', value: '10'),
    const FilterOption(label: '+25', value: '25'),
    const FilterOption(label: '+50', value: '50'),
    const FilterOption(label: '+100', value: '100'),
  ];

  static const dateDefault = FilterOption(label: '', value: 'daily');
  static List<FilterOption> get dateOptions => [
    FilterOption(value: 'daily', label: t.filter.day),
    FilterOption(value: 'weekly', label: t.filter.week),
    FilterOption(value: 'monthly', label: t.filter.month),
    FilterOption(value: 'yearly', label: t.filter.year),
    FilterOption(value: 'alltime', label: t.filter.allTime),
  ];
}
