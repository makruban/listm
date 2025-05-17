import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Platform-aware entrypoint for the Packing Lists screen.
/// Chooses Material or Cupertino scaffold based on OS.
class PackingListsScreen extends StatelessWidget {
  const PackingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoPackingListsScreen()
        : const MaterialPackingListsScreen();
  }
}

/// iOS-styled packing lists page.
class CupertinoPackingListsScreen extends StatelessWidget {
  const CupertinoPackingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.packingLists),
      ),
      child: const SafeArea(child: PackingListsView()),
    );
  }
}

/// Material-styled packing lists page.
class MaterialPackingListsScreen extends StatelessWidget {
  const MaterialPackingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.packingLists),
      ),
      body: const PackingListsView(),
    );
  }
}

/// Shared content of the Packing Lists screen.
/// Replace this with your real list view implementation.
class PackingListsView extends StatelessWidget {
  const PackingListsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Packing Lists Screen'),
    );
  }
}
