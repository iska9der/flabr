import 'package:dio/dio.dart';

import 'client_adapter_io.dart'
    if (dart.library.js_interop) 'client_adapter_web.dart'
    as adapter;

HttpClientAdapter makeHttpClientAdapter() => adapter.makeHttpClientAdapter();
