part of '../part.dart';

/// Кубит для управления состоянием [ScaffoldState] виджета [Scaffold]
///
/// Например, у нас есть [FloatingDrawerButton], который управляет
/// [Scaffold.drawer] с помощью метода [ScaffoldState.openDrawer].
/// Есть экран дашборда (например [UserDashboardPage]), который
/// является оберткой над всеми роутами, которые ему принадлежат.
/// Дашборду задается [Scaffold.drawer], и чтобы управлять им из низлежащих
/// страниц, необходимо вызывать [Scaffold.of] для текущего контекста,
/// который возвращает [ScaffoldState], и уже у него вызвать
/// [ScaffoldState.openDrawer] :
///
/// `Scaffold.of(context).openDrawer()`
///
/// НО! Так как в дочерних экранах дашборда могут быть свои [Scaffold],
/// поуправлять состоянием родительского [NavigationDrawer] не выйдет.
///
/// Поэтому мы на экране [UserDashboardPage] создаем наш [ScaffoldCubit],
/// в котором инициализируется [GlobalKey], и с помощью этого ключа [key]
/// в виджете [FloatingDrawerButton] мы можем вручную управлять
/// состоянием [Scaffold.drawer] :
///
/// `context.read<ScaffoldCubit>().key.currentState.openDrawer()`
///
class ScaffoldCubit extends Cubit<ScaffoldCubitState> {
  ScaffoldCubit() : super(ScaffoldCubitState(key: GlobalKey()));

  GlobalKey<ScaffoldState> get key => state.key;
}
