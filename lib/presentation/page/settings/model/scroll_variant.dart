part of 'config_model.dart';

const ScrollBehavior _material = MaterialScrollBehavior();
const ScrollBehavior _cupertino = CupertinoScrollBehavior();

enum ScrollVariant {
  material,
  cupertino,
  cupertinoFast
  ;

  String get label => switch (this) {
    .material => 'Material',
    .cupertino => 'Cupertino',
    .cupertinoFast => 'Cupertino Fast',
  };

  ScrollPhysics physics(BuildContext context) => switch (this) {
    /// для материала используем купертиновскую физику, так как
    /// по умолчанию Material не поддерживает overscroll
    /// и поэтому RefreshIndicator не работает
    .material => ScrollVariant.cupertinoFast.physics(context),
    _ => behavior.getScrollPhysics(context),
  };

  ScrollBehavior get behavior => switch (this) {
    .material => _material,
    .cupertino => _cupertino,
    .cupertinoFast => _cupertino.copyWith(
      physics: const BouncingScrollPhysics(decelerationRate: .fast),
    ),
  };
}
