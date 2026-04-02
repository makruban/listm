import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_base.dart';

/// A button that looks like a [TextButton] on Material and a [CupertinoButton] without background on iOS.
class AdaptiveTextButton extends AdaptiveWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;

  const AdaptiveTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
