import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../data/model/tracker/part.dart';
import '../../../../widget/enhancement/card.dart';
import '../../../../widget/user_text_button.dart';

class TrackerSkeletonWidget extends StatelessWidget {
  const TrackerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      child: FlabrCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserTextButton(TrackerNotificationUser(alias: 'Placeholder')),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Description of the card ' * 4,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const Text('Some stat'),
          ],
        ),
      ),
    );
  }
}
