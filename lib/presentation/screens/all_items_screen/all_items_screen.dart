import 'package:flutter/material.dart' hide showAdaptiveDialog;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripwise/domain/entities/item_entity.dart';
import 'package:tripwise/domain/value_objects/item_id.dart';
import 'package:tripwise/presentation/bloc/item/items_bloc.dart';

import 'package:tripwise/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_spinner.dart';
import 'package:tripwise/presentation/cubit/navigation_cubit.dart';
import 'package:tripwise/presentation/widgets/app_swipeable_card.dart';
import 'package:tripwise/presentation/widgets/checklist_painter.dart';
import 'package:tripwise/presentation/screens/packing_list_screen/widgets/simple_suitcase_icon.dart';
import 'package:tripwise/presentation/bloc/item/item_view_model.dart';
import 'package:tripwise/core/util/build_context_ext.dart';

/// Inline list widget for displaying and editing all items via ItemsBloc.
/// No Scaffold or FAB—embed in a parent widget that provides ItemsBloc.
class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({
    super.key,
    required this.hideFab,
    required this.showFab,
    required this.itemsBloc,
    this.showSearch = false,
    this.onCloseSearch,
  });
  final VoidCallback hideFab;
  final VoidCallback showFab;
  final ItemsBloc itemsBloc;
  final bool showSearch;
  final VoidCallback? onCloseSearch;

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  late ItemsBloc _itemsBloc;

  /// Currently editing placeholder ID (only one at a time)
  Key? _editingId;
  bool _isSubmitting = false;

  final _controllers = <Key, TextEditingController>{};
  final _focusNodes = <Key, FocusNode>{};
  final ScrollController _scrollController = ScrollController();

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
      if (_isNameTaken(entityId, trimmed)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(context.loc.itemAlreadyExistsError),
            behavior: SnackBarBehavior.floating,
          ));
        }
        final exists = _isExisting(entityId);
        if (!exists) {
          _itemsBloc.add(RemoveItemEvent(ItemId(entityId)));
        }
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

  bool _isNameTaken(String idToIgnore, String name) {
    final st = _itemsBloc.state;
    if (st is ItemsLoadSuccess) {
      final lowerName = name.toLowerCase();
      return st.items.any(
          (e) => e.item.id != idToIgnore && e.item.title.toLowerCase() == lowerName);
    }
    return false;
  }

  void _confirmDelete(BuildContext context, ItemViewModel uiModel) {
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text(context.loc.deleteItemTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.deleteItemConfirmation(uiModel.item.title)),
            if (uiModel.tripNames.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                context.loc.itemUsedInTripsWarning,
                style: const TextStyle(
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
            child: Text(context.loc.cancelButton),
          ),
          AdaptiveDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _itemsBloc.add(RemoveItemEvent(ItemId(uiModel.item.id)));
            },
            child: Text(context.loc.deleteButton),
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
    _scrollController.dispose();
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

        // Scroll to bottom when a new empty item is added
        BlocListener<ItemsBloc, ItemsState>(
          listenWhen: (prev, curr) {
            if (prev is ItemsLoadSuccess && curr is ItemsLoadSuccess) {
              final prevHasEmpty = prev.items.any((e) => e.item.title.isEmpty);
              final currHasEmpty = curr.items.any((e) => e.item.title.isEmpty);
              return !prevHasEmpty && currHasEmpty;
            }
            return false;
          },
          listener: (context, state) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted && _scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
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
            if (!widget.showSearch) {
              widget.showFab(); // bring back the FAB after the list is stable
            }
          },
        ),
      ],
      child: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {
          if (state is ItemsLoadInProgress) {
            return const Center(child: AdaptiveSpinner());
          } else if (state is ItemsFailure) {
            return Center(
                child:
                    Text(context.loc.itemsLoadError(state.error.toString())));
          } else if (state is ItemsLoadSuccess) {
            final displayItems = state.filteredItems;
            
            Widget bodyContent;
            if (state.items.isEmpty) {
              bodyContent = const _AllItemsEmptyState();
            } else if (displayItems.isEmpty) {
              bodyContent = Center(
                child: Text(
                  context.loc.noItemsAvailableToAdd,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              );
            } else {
              bodyContent = GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _onBackgroundTap,
                child: ListView.separated(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final uiModel = displayItems[index];
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
                              labelText:
                                  context.loc.itemCounterLabel(index + 1),
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
                        label: context.loc.infoAction,
                        onTap: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (dialogContext) => AdaptiveAlertDialog(
                              title: Text(dialogContext.loc.itemDetailsTitle),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dialogContext.loc
                                      .itemTitleLabel(item.title)),
                                  Text(dialogContext.loc.itemIdLabel(item.id)),
                                ],
                              ),
                              actions: [
                                AdaptiveDialogAction(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text(dialogContext.loc.closeButton),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SwipeAction(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        label: context.loc.deleteAction,
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
                          leading: _HighlightedText(
                            text: item.title,
                            query: state.searchQuery,
                            highlightColor: Theme.of(context).colorScheme.primary,
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
                                  context.loc.notPackedLabel,
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
                            if (_editingId != null) {
                              _submitOrCancel(_editingId!);
                            }
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
          }
          
          return Column(
            children: [
              Expanded(child: bodyContent),
              if (widget.showSearch)
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: _AllItemsSearchBar(onClose: widget.onCloseSearch),
                ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
        },
      ),
    );
  }
}

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
                        baseColor: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.2)))),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
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
                context.loc.emptyInventoryTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.emptyInventorySub,
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

class _AllItemsSearchBar extends StatefulWidget {
  final VoidCallback? onClose;
  const _AllItemsSearchBar({this.onClose});

  @override
  State<_AllItemsSearchBar> createState() => _AllItemsSearchBarState();
}

class _AllItemsSearchBarState extends State<_AllItemsSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: context.loc.searchHint,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      context.read<ItemsBloc>().add(ItemsSearchQueryChanged(val));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            context.read<ItemsBloc>().add(const ItemsSearchQueryChanged(''));
            widget.onClose?.call();
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final Color highlightColor;

  const _HighlightedText({
    required this.text,
    required this.query,
    this.style,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    if (!lowerText.contains(lowerQuery)) {
      return Text(text, style: style);
    }
    
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start), style: style));
        }
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style?.copyWith(
          color: highlightColor,
          fontWeight: FontWeight.bold,
        ) ?? TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
      ));
      start = index + query.length;
    }
    
    return RichText(
      text: TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
