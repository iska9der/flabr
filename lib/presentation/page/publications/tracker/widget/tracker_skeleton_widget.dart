import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../theme/part.dart';
import '../../../../widget/enhancement/card.dart';

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
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: kAvatarHeight,
                      height: kAvatarHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            kBorderRadiusDefault,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Author Placeholder',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
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
