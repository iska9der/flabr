import 'package:flutter/material.dart';

import '../extension/extension.dart';

class DashboardDrawerLinkWidget extends StatelessWidget {
  const DashboardDrawerLinkWidget({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(title),
          if (count != null && count! > 0)
            Text(
              '+$count',
              style: TextStyle(
                color: context.theme.colors.highlight,
                fontSize: 11,
                fontVariations: [const FontVariation('wght', 500)],
              ),
            ),
        ],
      ),
    );
  }
}
