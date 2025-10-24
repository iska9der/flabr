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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(animation);

    // Запускаем бесконечную анимацию пульсации
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IconsAssets.logoBackgroundColor,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Image.asset(
            IconsAssets.logoWithBackground,
            width: 260,
            height: 260,
          ),
        ),
      ),
    );
  }
}
