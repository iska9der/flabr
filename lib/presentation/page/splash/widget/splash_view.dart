part of '../splash.dart';

class _SplashView extends StatefulWidget {
  // ignore: unused_element_parameter
  const _SplashView({super.key});

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final double _scale = .75;

  @override
  void initState() {
    super.initState();

    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const .new(milliseconds: 600),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: _scale,
      end: _scale * .9,
    ).animate(animation);

    // Запускаем бесконечную анимацию
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Image.asset(IconsAssets.logo, fit: .fitWidth),
        ),
      ),
    );
  }
}
