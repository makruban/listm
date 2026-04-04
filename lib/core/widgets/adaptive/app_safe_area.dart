import 'package:flutter/material.dart';

/// A wrapper around [SafeArea] that dynamically disables the bottom padding
/// when the keyboard is open. This prevents double padding (from [Scaffold.resizeToAvoidBottomInset] 
/// stacking with [SafeArea]) and ensures the content sits correctly above the keyboard.
class AppSafeArea extends StatelessWidget {
  /// Constructor.
  const AppSafeArea({Key? key, required this.child}) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = viewInsets > 0;
    return SafeArea(
      top: false,
      bottom: !isKeyboardOpen,
      child: child,
    );
  }
}
