import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'all_items_screen.dart';
import 'packing_lists_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    final loc = AppLocalizations.of(context);
    return BlocProvider<NavigationCubit>(
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
                    icon: _icons[0], label: loc!.packingLists),
                BottomNavigationBarItem(icon: _icons[1], label: loc.allItems),
              ],
              onTap: (i) => context
                  .read<NavigationCubit>()
                  .setTab(NavigationTab.values[i]),
            ),
            floatingActionButton: _buildFloatingActionButton(tab),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton(NavigationTab tab) {
    if (tab == NavigationTab.packingLists || tab == NavigationTab.allItems) {
      return FloatingActionButton(
        onPressed: () {
          if (tab == NavigationTab.packingLists) {
            // TODO: Implement add packing list
          } else if (tab == NavigationTab.allItems) {
            // TODO: Implement add all items.
          } else {
            // nothing
          }
        },
        child: Icon(Icons.add),
      );
    } else {
      return null;
    }
  }
}
