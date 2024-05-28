import 'package:flutter/material.dart';

import '../../../config/constants.dart';

class FlabrTextButton extends TextButton {
  const FlabrTextButton.rectangle({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    super.isSemanticButton,
    required super.child,
  });

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return super.defaultStyleOf(context).copyWith(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadiusDefault),
            ),
          ),
        );
  }
}
