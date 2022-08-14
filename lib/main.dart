import 'package:flabr/components/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/di/dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Залочить вертикальную ориентацию
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = getIt.get<AppRouter>();

    return MaterialApp.router(
      title: 'Flabr',
      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
