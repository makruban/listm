import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'package:listm/presentation/screens/packing_list_screen/cupertino_packing_lists_screen.dart';
import 'package:listm/presentation/screens/packing_list_screen/packing_lists_screen.dart';
import 'package:listm/screens/all_items_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// iOS-styled main screen with bottom tabs and add-actions in the navigation bar.
class CupertinoMainScreen extends StatefulWidget {
  const CupertinoMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoMainScreen> createState() => _CupertinoMainScreenState();
}

class _CupertinoMainScreenState extends State<CupertinoMainScreen> {
  /// Navigation cubit to manage the current tab
  late NavigationCubit _navigationCubit;

  late ItemsBloc _itemsBloc;
  late TripsBloc _tripsBloc;
  late AppLocalizations _loc;

  bool _isInitialized = false;
  late List<_TabInfo> _tabs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // Grab injected cubits/blocs and localization
      _navigationCubit = context.read<NavigationCubit>();
      _itemsBloc = context.read<ItemsBloc>();
      _tripsBloc = context.read<TripsBloc>();
      _loc = AppLocalizations.of(context)!;

      // Build tab metadata
      _tabs = [
        _TabInfo(
          page: const CupertinoPackingListsScreen(),
          navBarBuilder: (ctx) => CupertinoNavigationBar(
            middle: Text(_loc.packingLists),
            trailing: _buildAddButton(0),
          ),
          navBarItem: BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.square_list),
            label: _loc.packingLists,
          ),
        ),
        _TabInfo(
          page: const AllItemsScreen(),
          navBarBuilder: (ctx) => CupertinoNavigationBar(
            middle: Text(_loc.allItems),
            trailing: _buildAddButton(1),
          ),
          navBarItem: BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.square_fill_on_square_fill),
            label: _loc.allItems,
          ),
        ),
      ];

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationTab>(
      builder: (context, tab) {
        return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            currentIndex: tab.index,
            items: _tabs.map((t) => t.navBarItem).toList(),
            onTap: (i) => _navigationCubit.setTab(NavigationTab.values[i]),
          ),
          tabBuilder: (ctx, index) {
            final info = _tabs[index];
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: info.navBarBuilder(ctx),
              ),
              child: SafeArea(child: info.page),
            );
          },
        );
      },
    );
  }

  /// Builds the "add" button for each tab in the navigation bar.
  /// TODO: there is no Tooltip in Cupertino, so we need to try to show CupertinoContextMenu
  Widget? _buildAddButton(int index) {
    if (index == NavigationTab.packingLists.index) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          // TODO: show input and then dispatch AddTripEvent
          // _tripsBloc.add(AddTripEvent(newTrip));
        },
      );
    } else if (index == NavigationTab.allItems.index) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          // TODO: show input and then dispatch AddItemEvent
          // _itemsBloc.add(AddItemEvent(newItem));
        },
      );
    }
    return null;
  }
}

/// Helper class to encapsulate each tab’s page, navigation bar, and tab item.
class _TabInfo {
  final Widget Function(BuildContext) navBarBuilder;
  final Widget page;
  final BottomNavigationBarItem navBarItem;

  const _TabInfo({
    required this.page,
    required this.navBarBuilder,
    required this.navBarItem,
  });
}
