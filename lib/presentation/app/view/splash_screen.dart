import 'package:flutter/material.dart';

import '../../constants/constants.dart';

/// Splash screen с анимированным логотипом.
///
/// Отображает логотип приложения по центру на синем фоне
/// с эффектом медленной пульсации.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _calculate();

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: _scale,
      end: _scale * .90,
    ).animate(animation);

    // Запускаем бесконечную анимацию пульсации
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculate() {
    _scale = .75;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, _) => Scaffold(
        backgroundColor: IconsAssets.logoBackgroundColor,
        body: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Image.asset(
              IconsAssets.logo,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
