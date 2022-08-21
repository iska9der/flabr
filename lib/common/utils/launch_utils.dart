import '../../components/router/router.gr.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LaunchUtils {
  const LaunchUtils({required this.router});

  final AppRouter router;

  Future launchUrl(String url) async {
    if (url.contains('habr.com')) {
      if (url.contains('post') ||
          url.contains('blog') ||
          url.contains('news')) {
        String id = parsePostId(url);

        return await router.push(ArticleRoute(id: id));
      }
    }

    return await launchUrlString(url);
  }

  String parsePostId(String url) {
    Iterable<String> parts =
        url.split('/').where((element) => element.isNotEmpty);

    return parts.last;
  }
}
