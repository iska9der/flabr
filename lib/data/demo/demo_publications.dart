import '../model/language/language.dart';
import '../model/publication/publication.dart';

typedef DemoPublication = ({
  Language language,
  PublicationFlow flow,
  PublicationCommon publication,
});

/// Короткие фрагменты оригинальных статей и авторская демоновость для каждого языка.
/// Источники метаданных, текста и иллюстраций:
/// https://habr.com/en/companies/qrator/articles/593741/
/// https://habr.com/ru/articles/335382/
/// Карточки используют сокращённый лид, а читатель — отдельный фрагмент статьи.
/// Общий демонстрационный аватар не меняет идентификаторы и псевдонимы авторов:
/// https://assets.habr.com/habr-web/release_2.346.2/client/img/avatars/180.png
final List<DemoPublication> demoPublications = List.unmodifiable([
  (
    language: Language.en,
    flow: PublicationFlow.admin,
    publication: _englishArticle(),
  ),
  _news(Language.en),
  (
    language: Language.ru,
    flow: PublicationFlow.mobileDevelopment,
    publication: _russianArticle(),
  ),
  _news(Language.ru),
]);

PublicationCommon _englishArticle() {
  const lead =
      'DDoS attacks send ripples on the ocean of the Internet, '
      'produced by creations of various sizes - botnets.';
  const image = 'assets/demo/article_593741.png';
  return const PublicationCommon(
    id: '593741',
    type: PublicationType.article,
    timePublished: '2021-12-06T15:47:00+00:00',
    author: PublicationAuthor(
      id: '25440',
      alias: 'Shapelez',
      avatarUrl: 'assets/demo/avatar.png',
    ),
    titleHtml: 'New botnet with lots of cameras and some routers',
    leadData: PublicationLeadData(
      textHtml: '<p>$lead</p>',
      imageUrl: image,
      image: PublicationLeadImage(url: image, fit: 'cover'),
    ),
    textHtml:
        '<p>$lead '
        'Some of them feed at the top of the ocean, but there also exists '
        'a category of huge, deep water monstrosities that are rare and '
        'dangerous enough they could be seen only once in a very long time.</p>'
        '<p>But let us first show you the data we’ve gathered, and leave '
        'conclusions closer to the end of this post.</p>'
        '<img src="$image" width="980" height="530">',
    hubs: [
      PublicationHub(
        id: '11571',
        alias: 'qrator',
        title: 'Qrator Labs corporate blog',
        type: .corporative,
      ),
      PublicationHub(
        id: '50',
        alias: 'infosecurity',
        title: 'Information Security',
        isProfiled: true,
      ),
      PublicationHub(
        id: '6398',
        alias: 'it-infrastructure',
        title: 'IT Infrastructure',
        isProfiled: true,
      ),
      PublicationHub(
        id: '17123',
        alias: 'network_technologies',
        title: 'Network technologies',
        isProfiled: true,
      ),
    ],
    readingTime: 3,
    statistics: PublicationStatistics(
      favoritesCount: 3,
      readingCount: 2421,
      score: 12,
      votesCount: 12,
      votesCountPlus: 12,
    ),
  );
}

PublicationCommon _russianArticle() {
  const lead =
      'На первый взгляд, <em>Clean Architecture</em> – довольно простой набор '
      'рекомендаций к построению приложений. Но и я, и многие мои коллеги, '
      'сильные разработчики, осознали эту архитектуру не сразу.';
  const image =
      '<img src="assets/demo/article_335382.png" '
      'alt="Превращаем круги в блоки" width="1920" height="639">';
  return const PublicationCommon(
    id: '335382',
    type: PublicationType.article,
    timePublished: '2017-08-11T07:39:08+00:00',
    author: PublicationAuthor(
      id: '1320150',
      alias: 'Jeevuz',
      avatarUrl: 'assets/demo/avatar.png',
    ),
    titleHtml: 'Заблуждения Clean Architecture',
    leadData: PublicationLeadData(textHtml: '$image<p>$lead</p>'),
    textHtml:
        '$image<p>$lead '
        'А в последнее время в чатах и интернете я вижу всё больше ошибочных '
        'представлений, связанных с ней. <strong>Этой статьёй я хочу помочь '
        'сообществу лучше понять Clean Architecture и избавиться от '
        'распространенных заблуждений</strong>.</p>'
        '<p>Сразу хочу оговориться, заблуждения – это дело личное. '
        'Каждый в праве заблуждаться. И если это его устраивает, '
        'то я не хочу мешать.</p>',
    hubs: [
      PublicationHub(
        id: '20878',
        alias: 'mobileup',
        title: 'Блог компании MobileUp',
        type: .corporative,
      ),
      PublicationHub(
        id: '359',
        alias: 'programming',
        title: 'Программирование',
        isProfiled: true,
      ),
      PublicationHub(
        id: '7504',
        alias: 'refactoring',
        title: 'Проектирование и рефакторинг',
        isProfiled: true,
      ),
      PublicationHub(
        id: '6345',
        alias: 'mobile_dev',
        title: 'Разработка мобильных приложений',
        isProfiled: true,
      ),
      PublicationHub(
        id: '17107',
        alias: 'android_dev',
        title: 'Android',
        isProfiled: true,
      ),
    ],
    readingTime: 15,
    statistics: PublicationStatistics(
      commentsCount: 204,
      readingCount: 465722,
      favoritesCount: 1431,
      score: 54,
      votesCount: 58,
      votesCountPlus: 56,
      votesCountMinus: 2,
    ),
  );
}

DemoPublication _news(Language language) {
  final ru = language == Language.ru;
  final prefix = ru ? '92' : '91';
  final excerpt = ru
      ? '<p>В учебном прототипе собрали статьи и иллюстрации в одну локальную библиотеку. Читать можно без подключения к сети.</p>'
      : '<p>The learning prototype brings articles and illustrations into one local library, ready to read without a connection.</p>';
  return (
    language: language,
    flow: PublicationFlow.mobileDevelopment,
    publication: PublicationCommon(
      id: '${prefix}0011',
      type: PublicationType.news,
      timePublished: '2017-08-10T09:00:00+00:00',
      author: PublicationAuthor(
        id: '${prefix}0000',
        alias: ru ? 'Демо-студия' : 'Demo Studio',
      ),
      titleHtml: ru
          ? 'Дневник демопроекта: локальная библиотека'
          : 'Demo project notes: a local reading library',
      leadData: PublicationLeadData(textHtml: excerpt),
      textHtml: excerpt,
      hubs: [
        PublicationHub(
          id: '1',
          alias: 'mobile_development',
          title: ru ? 'Мобильная разработка' : 'Mobile development',
        ),
      ],
      readingTime: 2,
      statistics: const PublicationStatistics(
        readingCount: 860,
        favoritesCount: 12,
        score: 18,
        votesCount: 18,
        votesCountPlus: 18,
      ),
    ),
  );
}
