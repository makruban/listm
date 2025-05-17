import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'all_items_screen.dart';
import 'packing_lists_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// lib/presentation/screens/main_screen.dart

/// Top-level entrypoint: picks the right scaffold for each platform.
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? const CupertinoMainScreen() : MaterialMainScreen();
  }
}

/// Material version of the main screen with bottom tabs and FAB.
class MaterialMainScreen extends StatelessWidget {
  MaterialMainScreen({Key? key}) : super(key: key);

  final GlobalKey<TooltipState> _fabTooltipKey = GlobalKey<TooltipState>();
  static const _screens = [
    PackingListsScreen(),
    AllItemsScreen(),
  ];

  static const _icons = [
    Icon(Icons.list),
    Icon(Icons.all_inbox),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _fabTooltipKey.currentState?.ensureTooltipVisible());
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationTab>(
        builder: (context, tab) {
          return Scaffold(
            body: IndexedStack(
              index: tab.index,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tab.index,
              items: [
                BottomNavigationBarItem(
                  icon: _icons[0],
                  label: loc.packingLists,
                ),
                BottomNavigationBarItem(
                  icon: _icons[1],
                  label: loc.allItems,
                ),
              ],
              onTap: (i) => context
                  .read<NavigationCubit>()
                  .setTab(NavigationTab.values[i]),
            ),
            floatingActionButton: Tooltip(
              key: _fabTooltipKey,
              preferBelow: false,
              verticalOffset: 50,
              message: 'Click here to add your first trip',
              child: _buildFab(context, tab),
            ),
            // floatingActionButton: _buildFab(context, tab),
          );
        },
      ),
    );
  }

  Widget? _buildFab(BuildContext context, NavigationTab tab) {
    // only show FAB on our two main tabs
    if (tab == NavigationTab.packingLists || tab == NavigationTab.allItems) {
      return FloatingActionButton(
        onPressed: () {
          if (tab == NavigationTab.packingLists) {
            // TODO: show "Add Trip" flow
          } else {
            // TODO: show "Add Item" flow
          }
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
}

/// Cupertino version of the main screen with bottom tabs (no FAB by default).
class CupertinoMainScreen extends StatelessWidget {
  const CupertinoMainScreen({Key? key}) : super(key: key);

  static const _screens = [
    PackingListsScreen(),
    AllItemsScreen(),
  ];

  static const _icons = [
    Icon(CupertinoIcons.square_list),
    Icon(CupertinoIcons.square_fill_on_square_fill),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationTab>(
        builder: (context, tab) {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: tab.index,
              items: [
                BottomNavigationBarItem(
                  icon: _icons[0],
                  label: loc.packingLists,
                ),
                BottomNavigationBarItem(
                  icon: _icons[1],
                  label: loc.allItems,
                ),
              ],
              onTap: (i) => context
                  .read<NavigationCubit>()
                  .setTab(NavigationTab.values[i]),
            ),
            tabBuilder: (context, index) {
              // Each tab gets its own page scaffold and AppBar
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text(
                    index == 0 ? loc.packingLists : loc.allItems,
                  ),
                ),
                child: SafeArea(child: _screens[index]),
              );
            },
          );
        },
      ),
    );
  }
}
