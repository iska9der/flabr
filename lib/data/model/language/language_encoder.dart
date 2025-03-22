import 'language_enum.dart';

abstract class LanguageEncoder {
  static String encodeLangs(List<Language> languages) {
    String result = '';

    for (var i = 0; i < languages.length; i++) {
      result += languages[i].name;

      if (i != languages.length - 1) {
        result += ',';
      }
    }

    return result;
  }

  static List<Language> decodeLangs(String langs) {
    List<Language> enums = [];

    List<String> spl = langs.split(',');

    enums.addAll(spl.map((e) => Language.fromString(e)));

    return enums;
  }
}
