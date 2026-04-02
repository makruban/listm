import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'adaptive_base.dart';

class AdaptiveButton extends AdaptiveWidget {
  final String text;
  final VoidCallback onPressed;

  const AdaptiveButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
