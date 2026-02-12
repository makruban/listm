import 'package:flutter/material.dart' hide showAdaptiveDialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/di/injection.dart';
import 'package:listm/domain/entities/trip_detail_item.dart';
import 'package:listm/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:listm/presentation/bloc/trip_item_selector/trip_item_selector_bloc.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';
import 'package:listm/core/util/list_diff_util.dart';
import 'package:listm/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:listm/core/widgets/adaptive/adaptive_scaffold.dart';
import 'package:listm/core/widgets/adaptive/adaptive_spinner.dart';

class MaterialTripDetailScreen extends StatefulWidget {
  final String tripId;
  final bool isNewTrip;

  const MaterialTripDetailScreen({
    super.key,
    required this.tripId,
    this.isNewTrip = false,
  });

  @override
  State<MaterialTripDetailScreen> createState() =>
      _MaterialTripDetailScreenState();
}

class _MaterialTripDetailScreenState extends State<MaterialTripDetailScreen> {
  late TripDetailsBloc _tripDetailsBloc;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<TripDetailItem> _listData = [];
  bool _allCompleted = false;
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _tripDetailsBloc = getIt<TripDetailsBloc>();
    _tripDetailsBloc.add(LoadTripDetails(widget.tripId));
    _titleController = TextEditingController();
    _titleFocusNode = FocusNode();

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        _tripDetailsBloc.add(UpdateTripTitle(_titleController.text));
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _tripDetailsBloc,
      child: BlocListener<TripDetailsBloc, TripDetailsState>(
        listener: (context, state) {
          if (state is TripDetailsLoaded) {
            // Handle List Diffing
            if (_listData.isEmpty &&
                state.items.isNotEmpty &&
                _listKey.currentState == null) {
              // Initial load (before list is attached) or first data
              // If _listKey.currentState is null, we can't animate yet.
              // Just populate data. The AnimatedList will read it on build.
              _listData.clear();
              _listData.addAll(state.items);
            } else {
              // List is likely active, or we have updates.
              // Calculate Diff
              final operations = ListDiffUtil.calculateDiff<TripDetailItem>(
                _listData,
                state.items,
                (item) => item.item.id,
              );

              for (final op in operations) {
                if (op is RemoveOperation<TripDetailItem>) {
                  final removedItem = op.item;
                  // Ensure index is valid
                  if (op.index < _listData.length) {
                    _listData.removeAt(op.index);
                    _listKey.currentState?.removeItem(
                      op.index,
                      (context, animation) =>
                          _buildItem(removedItem, animation),
                    );
                  }
                } else if (op is InsertOperation<TripDetailItem>) {
                  if (op.index <= _listData.length) {
                    _listData.insert(op.index, op.item);
                    _listKey.currentState?.insertItem(op.index);
                  }
                }
              }

              // Sync data content for items that didn't move or were just moved
              // This is crucial because ListDiffUtil logic might skip updates for ID matches
              for (int i = 0; i < state.items.length; i++) {
                if (i < _listData.length) {
                  _listData[i] = state.items[i];
                }
              }

              // Force UI rebuild to reflect data changes (like checkboxes)
              setState(() {});

              // Check for all completed
              final isAllCompleted = state.items.isNotEmpty &&
                  state.items.every((i) => i.isCompleted);

              if (isAllCompleted && !_allCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showCongratulationsDialog();
                });
              }
              _allCompleted = isAllCompleted;
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: AdaptiveScaffold(
            materialAppBar: (context) => AppBar(
              title: BlocConsumer<TripDetailsBloc, TripDetailsState>(
                listener: (context, state) {
                  if (state is TripDetailsLoaded) {
                    if (!_titleFocusNode.hasFocus) {
                      _titleController.text = state.trip.title;
                    }
                  }
                },
                builder: (context, state) {
                  if (state is TripDetailsLoaded) {
                    final theme = Theme.of(context);
                    return TextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.appBarTheme.foregroundColor ??
                                theme.colorScheme.onSurface,
                          ) ??
                          const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Trip Title',
                        hintStyle: theme.textTheme.titleLarge?.copyWith(
                          color: (theme.appBarTheme.foregroundColor ??
                                  theme.colorScheme.onSurface)
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      cursorColor: theme.appBarTheme.foregroundColor ??
                          theme.colorScheme.onSurface,
                      autofocus: widget.isNewTrip,
                      onSubmitted: (value) {
                        _tripDetailsBloc.add(UpdateTripTitle(value));
                      },
                    );
                  }
                  return const Text('Trip Details');
                },
              ),
            ),
            cupertinoNavigationBar: (context) => CupertinoNavigationBar(
              middle: BlocConsumer<TripDetailsBloc, TripDetailsState>(
                listener: (context, state) {
                  if (state is TripDetailsLoaded) {
                    if (!_titleFocusNode.hasFocus) {
                      _titleController.text = state.trip.title;
                    }
                  }
                },
                builder: (context, state) {
                  if (state is TripDetailsLoaded) {
                    return CupertinoTextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle,
                      placeholder: 'Trip Title',
                      decoration: null, // No border for cleaner look in nav bar
                      autofocus: widget.isNewTrip,
                      onSubmitted: (value) {
                        _tripDetailsBloc.add(UpdateTripTitle(value));
                      },
                    );
                  }
                  return const Text('Trip Details');
                },
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  _showAddItemsBottomSheet(context);
                },
              ),
            ),
            body: BlocBuilder<TripDetailsBloc, TripDetailsState>(
              builder: (context, state) {
                if (state is TripDetailsLoading) {
                  // Only show loading if we have no data?
                  // If we have _listData, we might want to stay visible?
                  // But standard pattern is:
                  return const Center(child: AdaptiveSpinner());
                } else if (state is TripDetailsLoaded) {
                  // If list data is not synced yet (e.g. first build), sync it validly
                  if (_listData.isEmpty && state.items.isNotEmpty) {
                    // This happens if listener didn't fire or fired before build?
                    // Safe sync to ensure viewing
                    _listData.clear();
                    _listData.addAll(state.items);
                  }

                  if (_listData.isEmpty) {
                    return const Center(child: Text('No items in this trip'));
                  }

                  return AnimatedList(
                    key: _listKey,
                    padding: const EdgeInsets.all(8),
                    initialItemCount: _listData.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= _listData.length) {
                        return const SizedBox.shrink();
                      }
                      return _buildItem(_listData[index], animation);
                    },
                  );
                } else if (state is TripDetailsError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showAddItemsBottomSheet(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(TripDetailItem item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: AppSwipeableCard(
          key: ValueKey(item.item.id),
          margin: const EdgeInsets.symmetric(vertical: 6),
          onDelete: () {
            _tripDetailsBloc.add(RemoveTripItem(item.item.id));
          },
          actions: [
            SwipeAction(
              icon: Icons.delete_outline,
              color: Colors.red,
              label: 'Remove',
              onTap: () {
                _tripDetailsBloc.add(RemoveTripItem(item.item.id));
              },
            ),
          ],
          child: Card(
            margin: const EdgeInsets.symmetric(
                vertical: 1), // Margin handled by AppSwipeableCard or wrapper
            child: ListTile(
              onTap: () {
                _tripDetailsBloc.add(
                  ToggleTripItemCompletion(item.item.id),
                );
              },
              title: Text(
                item.item.title,
                style: item.isCompleted
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      )
                    : Theme.of(context).textTheme.titleLarge,
              ),
              trailing: Checkbox(
                value: item.isCompleted,
                onChanged: (value) {
                  _tripDetailsBloc.add(
                    ToggleTripItemCompletion(item.item.id),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddItemsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => getIt<TripItemSelectorBloc>()
            ..add(LoadTripItemSelector(widget.tripId)),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  AppBar(
                    title: const Text('Add Items'),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Trigger a reload on the main bloc when closing to ensure sync
                          _tripDetailsBloc.add(LoadTripDetails(widget.tripId));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Create New Item'),
                    onTap: () {
                      _showCreateItemDialog(context);
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: BlocBuilder<TripItemSelectorBloc,
                        TripItemSelectorState>(
                      builder: (context, state) {
                        if (state is TripItemSelectorLoaded) {
                          if (state.availableItems.isEmpty) {
                            return const Center(
                              child: Text('No items available to add'),
                            );
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: state.availableItems.length,
                            itemBuilder: (context, index) {
                              final item = state.availableItems[index];
                              final isSelected =
                                  state.selectedItemIds.contains(item.id);

                              return CheckboxListTile(
                                value: isSelected,
                                title: Text(item.title),
                                subtitle: Text(item.description),
                                onChanged: (bool? value) {
                                  context.read<TripItemSelectorBloc>().add(
                                        ToggleItemSelection(
                                            item.id, value ?? false),
                                      );
                                },
                              );
                            },
                          );
                        } else if (state is TripItemSelectorError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      // Also refresh when dismissed by dragging or tapping outside
      _tripDetailsBloc.add(LoadTripDetails(widget.tripId));
    });
  }

  void _showCreateItemDialog(BuildContext parentContext) {
    // We need to access the Bloc from the bottom sheet context
    // But since the dialog is a new route, it can't see the bottom sheet's provider easily
    // unless we pass the bloc or wrap the dialog.
    // However, the _showCreateItemDialog is called FROM the bottom sheet structure.
    // Let's change the signature or usage to pass the context containing the bloc.
    final bloc = BlocProvider.of<TripItemSelectorBloc>(parentContext);
    final TextEditingController nameController = TextEditingController();

    showAdaptiveDialog(
      context: parentContext,
      builder: (context) {
        return AdaptiveAlertDialog(
          title: const Text('Create New Item'),
          content: Material(
            color: Colors.transparent,
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Toothbrush',
              ),
              autofocus: true,
            ),
          ),
          actions: [
            AdaptiveDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            AdaptiveDialogAction(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  bloc.add(CreateAndSelectNewItem(name));
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCongratulationsDialog() {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('All items are packed! You are ready to go!'),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
