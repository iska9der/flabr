import 'package:dio/dio.dart';
import 'package:dio/io.dart';

HttpClientAdapter makeHttpClientAdapter() {
  return IOHttpClientAdapter();
}
