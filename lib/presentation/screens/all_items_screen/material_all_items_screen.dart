import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/value_objects/item_id.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';
import 'package:listm/presentation/widgets/checklist_painter.dart';

/// Inline list widget for displaying and editing all items via ItemsBloc.
/// No Scaffold or FAB—embed in a parent widget that provides ItemsBloc.
class MaterialAllItemsScreen extends StatefulWidget {
  const MaterialAllItemsScreen({
    super.key,
    required this.hideFab,
    required this.showFab,
    required this.itemsBloc,
  });
  final VoidCallback hideFab;
  final VoidCallback showFab;
  final ItemsBloc itemsBloc;

  @override
  _MaterialAllItemsScreenState createState() => _MaterialAllItemsScreenState();
}

class _MaterialAllItemsScreenState extends State<MaterialAllItemsScreen> {
  late ItemsBloc _itemsBloc;

  /// Currently editing placeholder ID (only one at a time)
  Key? _editingId;
  bool _isSubmitting = false;

  final _controllers = <Key, TextEditingController>{};
  final _focusNodes = <Key, FocusNode>{};

  void _startEditing(Key id, {String initial = ''}) {
    // Commit or cancel any previous edit first.
    if (_editingId != null && _editingId != id) _submitOrCancel(_editingId!);

    setState(() => _editingId = id);
    widget.hideFab();

    _controllers[id] = TextEditingController(text: initial);
    final node = FocusNode();
    _focusNodes[id] = node;

    node.addListener(() {
      if (!node.hasFocus) _submitOrCancel(id);
    });

    // Request focus next frame to avoid layout timing issues.
    WidgetsBinding.instance.addPostFrameCallback((_) => node.requestFocus());
  }

  void _submitOrCancel(Key id) {
    _isSubmitting = true;
    final raw = _controllers[id]?.text ?? '';
    final trimmed = raw.trim();
    final entityId = (id as ValueKey<String>).value;

    // Ensure keyboard is dismissed; disposal is deferred.
    _focusNodes[id]?.unfocus();

    if (trimmed.isEmpty) {
      _itemsBloc.add(RemoveItemEvent(ItemId(entityId)));
    } else {
      final exists = _isExisting(entityId);
      if (exists) {
        _itemsBloc.add(UpdateItemEvent(
          ItemEntity(id: entityId, title: trimmed, description: ''),
        ));
      } else {
        _itemsBloc.add(AddItemEvent(name: trimmed));
      }
    }

    _disposeLater(id);
  }

  /// Defers disposal to the next frame, avoiding the notifyListeners assertion.
  void _disposeLater(Key id) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[id]?.dispose();
      _controllers[id]?.dispose();
      _focusNodes.remove(id);
      _controllers.remove(id);
      if (mounted) setState(() => _editingId = null);
    });
  }

  bool _isExisting(String id) {
    final st = _itemsBloc.state;
    return st is ItemsLoadSuccess && st.items.any((e) => e.id == id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _itemsBloc = widget.itemsBloc;
    _itemsBloc.add(const LoadItems());
    super.initState();
  }

  @override
  void dispose() {
    if (_editingId != null) {
      // If we are currently editing, dispose that editor:
      _disposeLater(_editingId!);
    }
    super.dispose();
  }

  /// Checks if the given entityId exists in the current ItemsLoadSuccess state.
  bool _isExistingItemId(String id) {
    final currentState = _itemsBloc.state;
    if (currentState is ItemsLoadSuccess) {
      return currentState.items.any((item) => item.id == id);
    }
    return false;
  }

  void _onBackgroundTap() {
    if (_editingId != null) _submitOrCancel(_editingId!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 1️⃣ If the user navigates away from the AllItems tab, cancel editing:
        BlocListener<NavigationCubit, NavigationTab>(
          listener: (context, tab) {
            if (tab != NavigationTab.allItems && _editingId != null) {
              _submitOrCancel(_editingId!);
            }
          },
        ),

        // 2️⃣ Once the bloc finishes loading the new state (after Add/Remove/Update),
        //     show the FAB again.
        BlocListener<ItemsBloc, ItemsState>(
          listenWhen: (prev, curr) {
            // We only care about the refreshed list
            if (curr is! ItemsLoadSuccess) return false;

            // 1. If we’re still editing AND NOT submitting, keep FAB hidden
            if (_editingId != null && !_isSubmitting) return false;
            // 2. If the list still has an “empty-title” placeholder, keep FAB hidden
            final stillHasPlaceholder =
                curr.items.any((e) => e.title.trim().isEmpty);
            return !stillHasPlaceholder;
          },
          listener: (context, state) {
            if (_isSubmitting) {
              setState(() => _editingId = null);
              _isSubmitting = false;
            }
            widget.showFab(); // bring back the FAB after the list is stable
          },
        ),
      ],
      child: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          if (state is ItemsLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemsFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is ItemsLoadSuccess) {
            if (state.items.isEmpty) {
              return _AllItemsEmptyState();
            }
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _onBackgroundTap,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 0.4),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final ItemEntity item = state.items[index];
                  final Key key = ValueKey<String>(item.id);
                  if (item.title.isEmpty) {
                    // Create with start editing mode if the title is empty
                    _editingId ??= key;
                  }
                  // ️Editing mode for this one key
                  if (_editingId == key) {
                    final controller = _controllers.putIfAbsent(
                        key, () => TextEditingController(text: item.title));
                    final focusNode = _focusNodes.putIfAbsent(key, () {
                      final node = FocusNode();
                      node.addListener(() {
                        if (!node.hasFocus) _submitOrCancel(key);
                      });
                      // request focus on first build only
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => node.requestFocus());
                      return node;
                    });
                    return ListTile(
                      title: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        maxLength: 15,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: 'Item ${index + 1}',
                            border: InputBorder.none,
                            counterText: ''),
                      ),
                    );
                  }
                  // Normal display mode
                  final GlobalKey itemKey = GlobalKey();
                  return AppSwipeableCard(
                    key: key,
                    onDelete: () {
                      // cancel any leftover edit first
                      if (_editingId != null) _submitOrCancel(_editingId!);
                      _itemsBloc.add(RemoveItemEvent(ItemId(item.id)));
                    },
                    actions: [
                      SwipeAction(
                        icon: Icons.info_outline,
                        color: Colors.green,
                        label: 'Info',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Item Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Title: ${item.title}'),
                                  Text('ID: ${item.id}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SwipeAction(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        label: 'Delete',
                        onTap: () {
                          // cancel any leftover edit first
                          if (_editingId != null) _submitOrCancel(_editingId!);
                          _itemsBloc.add(RemoveItemEvent(ItemId(item.id)));
                        },
                      ),
                    ],
                    child: GestureDetector(
                      onLongPress: () {
                        /// TODO: Consider using a context menu or a more accessible way to show options
                        /// TODO: or remove the long-press in favor of a trailing icon button
                      },
                      child: ListTile(
                        leading: Text(item.title),
                        // title: Text(item.title),
                        title: Row(
                          children: [
                            Text('used: 2'),
                            Spacer(),
                            AddToTripButton(),
                          ],
                        ),
                        onTap: () {
                          // cancel any leftover edit first
                          if (_editingId != null) _submitOrCancel(_editingId!);
                          if (item.title.isEmpty && _editingId == null) {
                            _startEditing(key, initial: '');
                          }

                          // begin editing this one
                          _startEditing(key, initial: item.title);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class AddToTripButton extends StatelessWidget {
  const AddToTripButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _showDialog(context),
        icon: Icon(
          Icons.add,
          color: Colors.green,
        ));
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Add to Trip'),
                content: const Text('Select a trip to add this item to.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ]));
  }
}

class _AllItemsEmptyState extends StatelessWidget {
  const _AllItemsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
                height: 500,
                width: 700,
                child: CustomPaint(
                    painter: ChecklistPainter(
                        baseColor: Colors.grey.shade300.withOpacity(0.3)))),
          ),
        ),
      ],
    );
    ;
  }
}
