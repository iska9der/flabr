import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AirplanePage extends StatelessWidget {
  const AirplanePage({super.key});

  static const String routePath = 'airplane';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оффлайн'),
      ),
      body: const Center(
        child: Text('Здесь будет оффлайн функционал'),
      ),
    );
  }
}
