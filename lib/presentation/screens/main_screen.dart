import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import 'all_items_screen.dart';
import 'packing_lists_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationTab>(
        builder: (context, tab) {
          return Scaffold(
            body: IndexedStack(
              index: tab.index,
              children: const [
                PackingListsScreen(),
                AllItemsScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tab.index,
              onTap: (index) => context
                  .read<NavigationCubit>()
                  .setTab(NavigationTab.values[index]),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Packing Lists',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.all_inbox),
                  label: 'All Items',
                ),
              ],
            ),
            floatingActionButton: tab == NavigationTab.packingLists
                ? FloatingActionButton(
                    onPressed: () {
                      // TODO: Implement add packing list
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }
}
