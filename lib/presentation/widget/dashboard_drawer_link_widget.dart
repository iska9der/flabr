import 'package:flutter/material.dart';

import '../extension/extension.dart';

class DashboardDrawerLinkWidget extends StatelessWidget {
  const DashboardDrawerLinkWidget({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(8),
      child: Row(
        mainAxisAlignment: .end,
        crossAxisAlignment: .start,
        spacing: 3,
        children: [
          Text(title),
          if (count != null && count! > 0)
            Text(
              '+$count',
              style: TextStyle(
                color: context.theme.colors.accentPositive,
                fontSize: 11,
                fontWeight: .w500,
              ),
            ),
        ],
      ),
    );
  }
}
