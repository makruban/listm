import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'adaptive_base.dart';

class AdaptiveSwitch extends AdaptiveWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}
