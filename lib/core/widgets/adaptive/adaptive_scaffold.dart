import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'adaptive_base.dart';
import 'app_safe_area.dart';

class AdaptiveScaffold extends AdaptiveWidget {
  final Widget body;
  final String? title;
  final Widget? trailing; // e.g., an action button
  final Widget? floatingActionButton;

  /// Builder for the Material [AppBar].
  final PreferredSizeWidget Function(BuildContext context)? materialAppBar;

  /// Builder for the Cupertino [CupertinoNavigationBar].
  final ObstructingPreferredSizeWidget Function(BuildContext context)?
      cupertinoNavigationBar;

  /// A bottom navigation bar to display at the bottom of the scaffold.
  ///
  /// On Material, this maps to [Scaffold.bottomNavigationBar].
  /// On Cupertino, this is rendered at the bottom of the screen.
  final Widget? bottomNavigationBar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.title,
    this.trailing,
    this.floatingActionButton,
    this.materialAppBar,
    this.cupertinoNavigationBar,
    this.bottomNavigationBar,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    return Scaffold(
      appBar: materialAppBar != null
          ? materialAppBar!(context)
          : AppBar(
              title: title != null ? Text(title!) : null,
              actions: trailing != null ? [trailing!] : null,
            ),
      body: AppSafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final scaffold = CupertinoPageScaffold(
      navigationBar: cupertinoNavigationBar != null
          ? cupertinoNavigationBar!(context)
          : CupertinoNavigationBar(
              middle: title != null ? Text(title!) : null,
              trailing: trailing,
            ),
      child: SafeArea(
        bottom: bottomNavigationBar == null,
        child: body,
      ),
    );

    if (bottomNavigationBar != null) {
      return Column(
        children: [
          Expanded(child: scaffold),
          bottomNavigationBar!,
        ],
      );
    }

    return scaffold;
  }
}
