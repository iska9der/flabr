part of 'part.dart';

String encodeLangs(List<LanguageEnum> languages) {
  String result = '';

  for (var i = 0; i < languages.length; i++) {
    result += languages[i].name;

    if (i != languages.length - 1) {
      result += ',';
    }
  }

  return result;
}

List<LanguageEnum> decodeLangs(String langs) {
  List<LanguageEnum> enums = [];

  List<String> spl = langs.split(',');

  enums.addAll(spl.map((e) => LanguageEnum.fromString(e)));

  return enums;
}
