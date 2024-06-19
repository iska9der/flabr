import 'package:flutter/material.dart';

class DashboardDrawerLinkWidget extends StatelessWidget {
  const DashboardDrawerLinkWidget({
    super.key,
    required this.title,
    this.count,
  });

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title),
          if (count != null && count! > 0) ...[
            const SizedBox(width: 6),
            Text(
              '+$count',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }
}
