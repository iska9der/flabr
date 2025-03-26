import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

HttpClientAdapter makeHttpClientAdapter() {
  return BrowserHttpClientAdapter()..withCredentials = true;
}
