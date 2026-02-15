part of 'most_reading_widget.dart';

class _Button extends StatefulWidget {
  const _Button();

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RepaintBoundary(
      child: FlabrCard(
        margin: .zero,
        padding: .zero,
        child: AppExpansionPanelList(
          elevation: 0,
          expansionCallback: (_, isExpanded) {
            setState(() => isShow = !isExpanded);
          },
          children: [
            AppExpansionPanel(
              isExpanded: isShow,
              canTapOnHeader: true,
              backgroundColor: Colors.transparent,
              headerBuilder: (context, isExpanded) {
                return Align(
                  alignment: .centerLeft,
                  child: Padding(
                    padding: const .only(left: 12),
                    child: Text(
                      'Читают сейчас',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                );
              },
              body: const _ListView(),
            ),
          ],
        ),
      ),
    );
  }
}
