import 'package:flutter/material.dart' hide showAdaptiveDialog;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/value_objects/item_id.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';

import 'package:listm/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:listm/core/widgets/adaptive/adaptive_spinner.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';
import 'package:listm/presentation/widgets/checklist_painter.dart';
import 'package:listm/presentation/screens/packing_list_screen/widgets/simple_suitcase_icon.dart';
import 'package:listm/presentation/bloc/item/item_view_model.dart';

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
  State<MaterialAllItemsScreen> createState() => _MaterialAllItemsScreenState();
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
    return st is ItemsLoadSuccess && st.items.any((e) => e.item.id == id);
  }

  void _confirmDelete(BuildContext context, ItemViewModel uiModel) {
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: const Text('Delete Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${uiModel.item.title}"?'),
            if (uiModel.tripNames.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Attention! This item is used in Trip(s):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ...uiModel.tripNames.map((tripName) => Text('• $tripName')),
            ],
          ],
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          AdaptiveDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _itemsBloc.add(RemoveItemEvent(ItemId(uiModel.item.id)));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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

  void _onBackgroundTap() {
    if (_editingId != null) _submitOrCancel(_editingId!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ️If the user navigates away from the AllItems tab, cancel editing:
        BlocListener<NavigationCubit, NavigationTab>(
          listener: (context, tab) {
            if (tab != NavigationTab.allItems && _editingId != null) {
              _submitOrCancel(_editingId!);
            }
          },
        ),

        // Once the bloc finishes loading the new state (after Add/Remove/Update),
        // show the FAB again.
        BlocListener<ItemsBloc, ItemsState>(
          listenWhen: (prev, curr) {
            // We only care about the refreshed list
            if (curr is! ItemsLoadSuccess) return false;

            // 1. If we’re still editing AND NOT submitting, keep FAB hidden
            if (_editingId != null && !_isSubmitting) return false;
            // 2. If the list still has an “empty-title” placeholder, keep FAB hidden
            final stillHasPlaceholder =
                curr.items.any((e) => e.item.title.trim().isEmpty);
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
            return const Center(child: AdaptiveSpinner());
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final uiModel = state.items[index];
                  final ItemEntity item = uiModel.item;
                  final tripNames = uiModel.tripNames;
                  final tripCount = tripNames.length;
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
                    final theme = Theme.of(context);
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.5),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                    );
                  }
                  // Normal display mode
                  return AppSwipeableCard(
                    key: key,
                    onDelete: () {
                      // cancel any leftover edit first
                      if (_editingId != null) _submitOrCancel(_editingId!);
                      _confirmDelete(context, uiModel);
                    },
                    actions: [
                      SwipeAction(
                        icon: Icons.info_outline,
                        color: Colors.green,
                        label: 'Info',
                        onTap: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => AdaptiveAlertDialog(
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
                                AdaptiveDialogAction(
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
                          _confirmDelete(context, uiModel);
                        },
                      ),
                    ],
                    child: GestureDetector(
                      onLongPress: () {
                        /// TODO: Consider using a context menu or a more accessible way to show options
                        /// TODO: or remove the long-press in favor of a trailing icon button
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          title: Row(
                            children: [
                              const Spacer(),
                              if (tripCount > 0) ...[
                                const SimpleSuitcaseIcon(
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$tripCount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ] else ...[
                                Text(
                                  'Not packed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
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

// class AddToTripButton extends StatelessWidget {
//   const AddToTripButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         onPressed: () => _showDialog(context),
//         icon: Icon(
//           Icons.add,
//           color: Colors.green,
//         ));
//   }

//   void _showDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//                 title: const Text('Add to Trip'),
//                 content: const Text('Select a trip to add this item to.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: const Text('Cancel'),
//                   ),
//                 ]));
//   }
// }

class _AllItemsEmptyState extends StatelessWidget {
  const _AllItemsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        baseColor:
                            theme.colorScheme.outlineVariant.withValues(alpha: 0.2)))),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: theme.colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your inventory is empty',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to start adding items',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
