# ya_summary

Dart client for generating article summaries through HTTP endpoints of the Yandex 300 service.

The package is platform-independent and does not depend on Flutter.

## Requirements

- Dart 3.11 or newer
- A Yandex OAuth token accepted by `300.ya.ru`

## Installation

```shell
dart pub add ya_summary
```

## Usage

```dart
import 'package:dio/dio.dart';
import 'package:ya_summary/ya_summary.dart';

Future<String?> readToken() async {
  // Read the token from secure storage or another trusted source.
  return 'your-oauth-token';
}

Future<void> main() async {
  final api = SummaryApi(
    dio: Dio(),
    tokenProvider: readToken,
  );

  try {
    final summary = await api.fetchSummary(
      'https://habr.com/ru/articles/123456/',
    );

    print(summary.title);
    for (final thesis in summary.content) {
      print('- $thesis');
    }
    print(summary.sharingUrl);
  } on SummaryException catch (error) {
    switch (error.type) {
      case SummaryExceptionType.tokenMissing:
        print('OAuth token is missing');
      case SummaryExceptionType.unauthorized:
        print('OAuth token was rejected');
      case SummaryExceptionType.sharingUrlFetchFailed:
        print('Failed to create a sharing URL');
      case SummaryExceptionType.summaryFetchFailed:
        print('Failed to fetch the summary');
    }
  }
}
```

`tokenProvider` is called before every `fetchSummary` request. It may read a current token from secure storage, a database, or another asynchronous source. Returning `null` or an empty string throws `SummaryException` with `SummaryExceptionType.tokenMissing` without making an HTTP request.

The supplied `Dio` instance keeps its configured interceptors, adapter, timeouts, and other options. `SummaryApi` sets its base URL to `https://300.ya.ru/api` and adds the OAuth authorization header to summary requests.

## API

### `SummaryApi`

```dart
SummaryApi({
  required Dio dio,
  required Future<String?> Function() tokenProvider,
})
```

```dart
Future<SummaryModel> fetchSummary(String articleUrl)
```

### `SummaryModel`

| Field | Type | Description |
| --- | --- | --- |
| `title` | `String` | Generated summary title |
| `content` | `List<String>` | Generated theses |
| `sharingUrl` | `String` | Public summary URL returned by the API |

### Errors

| Type | Meaning |
| --- | --- |
| `tokenMissing` | The token provider returned `null` or an empty token |
| `unauthorized` | The API returned HTTP 401 or 403 |
| `sharingUrlFetchFailed` | The sharing URL request failed |
| `summaryFetchFailed` | The summary request failed or returned an unsuccessful status |

Response parsing errors are not wrapped in `SummaryException`.

## API stability

This package uses undocumented HTTP endpoints of the Yandex 300 service. Their behavior may change without notice.
