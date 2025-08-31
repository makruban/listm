import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'package:listm/presentation/screens/all_items_screen/material_all_items_screen.dart';
import 'package:listm/presentation/screens/packing_list_screen/material_packing_lists_screen.dart';
import 'package:listm/presentation/screens/packing_list_screen/packing_lists_screen.dart';
import 'package:listm/screens/all_items_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Material version of the main screen with bottom tabs and FAB.
class MaterialMainScreen extends StatefulWidget {
  const MaterialMainScreen({Key? key}) : super(key: key);

  @override
  State<MaterialMainScreen> createState() => _MaterialMainScreenState();
}

class _MaterialMainScreenState extends State<MaterialMainScreen>
    with TickerProviderStateMixin {
// Guard so we only show the tooltip once
  bool _tooltipScheduled = false;

  /// Cubit to manage navigation state
  late NavigationCubit _navigationCubit;
  late ItemsBloc _itemsBloc;
  late TripsBloc _tripsBloc;
  late AppLocalizations _loc;
// Once-only guards:
  bool _isInitialized = false;
  late List<_TabInfo> _tabs;

  // Animation controllers
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  @override
  initState() {
    super.initState();
    // Initialize FAB animation
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start with FAB visible
    _fabAnimationController.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      // 1️⃣ Grab your injected blocs and localizations
      _navigationCubit = context.read<NavigationCubit>();
      _itemsBloc = context.read<ItemsBloc>();
      _tripsBloc = context.read<TripsBloc>();
      _loc = AppLocalizations.of(context)!;

      // 2️⃣ Build your tab info with the real `loc`
      _tabs = [
        _TabInfo(
          page: const MaterialPackingListsScreen(),
          appBarBuilder: (context) => AppBar(
            title: Text(_loc.packingLists),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {})
            ],
          ),
          navBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: _loc.packingLists,
          ),
        ),
        _TabInfo(
          page: MaterialAllItemsScreen(hideFab: _hideFab, showFab: _showFab),
          appBarBuilder: (context) => AppBar(
            title: Text(_loc.allItems),
            actions: [
              IconButton(icon: const Icon(Icons.settings), onPressed: () {})
            ],
          ),
          navBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.all_inbox),
            label: _loc.allItems,
          ),
        ),
      ];

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fabAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final _TabInfo currentTab = _tabs[_navigationCubit.state.index];
    return BlocBuilder<NavigationCubit, NavigationTab>(
      builder: (context, tab) {
        final _TabInfo currentTab = _tabs[tab.index];
        return Scaffold(
          appBar: currentTab.appBarBuilder(context),
          body: IndexedStack(
            index: tab.index,
            children: _tabs.map((tabInfo) => tabInfo.page).toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tab.index,
            items: _tabs.map((tabInfo) => tabInfo.navBarItem).toList(),
            onTap: (i) {
              // If leaving the AllItems tab, cancel any in-progress edit
              // if (_navigationCubit.state == NavigationTab.allItems) {}
              _navigationCubit.setTab(NavigationTab.values[i]);
            },
          ),
          floatingActionButton: ScaleTransition(
            scale: _fabScaleAnimation,
            child: _buildFab(context, tab),
          ),
          // floatingActionButton: _buildFab(context, tab),
        );
      },
    );
  }

  Widget? _buildFab(BuildContext context, NavigationTab tab) {
    // only show FAB on our two main tabs
    if (tab == NavigationTab.packingLists || tab == NavigationTab.allItems) {
      return FloatingActionButton(
        heroTag: 'fab_${tab.index}',
        onPressed: () {
          if (tab == NavigationTab.packingLists) {
            _tripsBloc.add(AddTripEvent());
          } else {
            // Hide FAB with animation
            _hideFab();
            _itemsBloc.add(AddItemEvent());
          }
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  void _hideFab() {
    // Hide FAB with animation
    _fabAnimationController.forward();
  }

  void _showFab() {
    // Show FAB with animation
    _fabAnimationController.reverse();
  }
}

// Helper class to encapsulate tab content and metadata
class _TabInfo {
  final Widget page;
  final PreferredSizeWidget Function(BuildContext) appBarBuilder;
  final BottomNavigationBarItem navBarItem;

  const _TabInfo({
    required this.page,
    required this.appBarBuilder,
    required this.navBarItem,
  });
}
