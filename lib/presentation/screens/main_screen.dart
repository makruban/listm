import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'all_items_screen.dart';
import 'packing_lists_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const _screens = [
    PackingListsScreen(),
    AllItemsScreen(),
  ];

  static final _items = [
    BottomNavigationBarItem(icon: _icons[0], label: _titles[0]),
    BottomNavigationBarItem(icon: _icons[1], label: _titles[1]),
  ];
  static const _titles = [
    'Packing Lists',
    'All Items',
  ];
  static const _icons = [
    Icon(Icons.list),
    Icon(Icons.all_inbox),
  ];
  @override
  Widget build(BuildContext context) {
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
              items: _items,
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
