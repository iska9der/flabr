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
    return RepaintBoundary(
      child: FlabrCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: AppExpansionPanelList(
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              isShow = !isExpanded;
            });
          },
          children: [
            AppExpansionPanel(
              isExpanded: isShow,
              canTapOnHeader: true,
              backgroundColor: Colors.transparent,
              headerBuilder: (context, isExpanded) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Читают сейчас',
                      style: Theme.of(context).textTheme.titleSmall,
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
