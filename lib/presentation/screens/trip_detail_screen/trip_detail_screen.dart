import 'package:flutter/material.dart' hide showAdaptiveDialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripwise/core/di/injection.dart';
import 'package:tripwise/domain/entities/trip_detail_item.dart';
import 'package:tripwise/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:tripwise/presentation/bloc/trip_item_selector/trip_item_selector_bloc.dart';
import 'package:tripwise/presentation/widgets/app_swipeable_card.dart';
import 'package:tripwise/core/util/list_diff_util.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_scaffold.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_spinner.dart';
import 'package:tripwise/core/util/build_context_ext.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;
  final bool isNewTrip;

  const TripDetailScreen({
    super.key,
    required this.tripId,
    this.isNewTrip = false,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late TripDetailsBloc _tripDetailsBloc;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<TripDetailItem> _listData = [];
  bool _allCompleted = false;
  bool _showClearAllButton = false;
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
              _listData.clear();
              _listData.addAll(state.items);
            } else {
              final operations = ListDiffUtil.calculateDiff<TripDetailItem>(
                _listData,
                state.items,
                (item) => item.item.id,
              );

              for (final op in operations) {
                if (op is RemoveOperation<TripDetailItem>) {
                  final removedItem = op.item;
                  if (op.index < _listData.length) {
                    _listData.removeAt(op.index);
                    _listKey.currentState?.removeItem(
                      op.index,
                      (context, animation) => _buildItem(removedItem, animation,
                          isFirstInGroup: op.index == 0,
                          isLastInGroup: op.index >= _listData.length),
                    );
                  }
                } else if (op is InsertOperation<TripDetailItem>) {
                  if (op.index <= _listData.length) {
                    _listData.insert(op.index, op.item);
                    _listKey.currentState?.insertItem(op.index);
                  }
                }
              }

              for (int i = 0; i < state.items.length; i++) {
                if (i < _listData.length) {
                  _listData[i] = state.items[i];
                }
              }

              setState(() {});

              final isAllCompleted = state.items.isNotEmpty &&
                  state.items.every((i) => i.isCompleted);

              if (isAllCompleted && !_allCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showCongratulationsDialog();
                });
              } else if (!isAllCompleted && _showClearAllButton) {
                setState(() {
                  _showClearAllButton = false;
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
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ) ??
                          const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: context.loc.tripTitleHint,
                        hintStyle: theme.textTheme.titleLarge?.copyWith(
                          color: (theme.appBarTheme.foregroundColor ??
                                  theme.colorScheme.onSurface)
                              .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
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
                  return Text(context.loc.tripDetailsNavTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, letterSpacing: -0.5));
                },
              ),
              actions: [
                if (_showClearAllButton)
                  TextButton(
                    onPressed: () {
                      _tripDetailsBloc.add(const UnselectAllTripItems());
                      setState(() {
                        _showClearAllButton = false;
                      });
                    },
                    child: Text(context.loc.clearAllButton),
                  ),
              ],
              elevation: 0,
              scrolledUnderElevation: 2,
              backgroundColor: Theme.of(context).colorScheme.surface,
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
                      placeholder: context.loc.tripTitleHint,
                      decoration: null, // No border for cleaner look in nav bar
                      autofocus: widget.isNewTrip,
                      onSubmitted: (value) {
                        _tripDetailsBloc.add(UpdateTripTitle(value));
                      },
                    );
                  }
                  return Text(context.loc.tripDetailsNavTitle);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showClearAllButton)
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(context.loc.clearButton),
                      onPressed: () {
                        _tripDetailsBloc.add(const UnselectAllTripItems());
                        setState(() {
                          _showClearAllButton = false;
                        });
                      },
                    ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () {
                      final state = _tripDetailsBloc.state;
                      final title = state is TripDetailsLoaded
                          ? state.trip.title
                          : context.loc.untitledTrip;
                      _showAddItemsBottomSheet(context, title);
                    },
                  ),
                ],
              ),
            ),
            body: BlocBuilder<TripDetailsBloc, TripDetailsState>(
              builder: (context, state) {
                if (state is TripDetailsLoading) {
                  return const Center(child: AdaptiveSpinner());
                } else if (state is TripDetailsLoaded) {
                  if (_listData.isEmpty && state.items.isNotEmpty) {
                    _listData.clear();
                    _listData.addAll(state.items);
                  }

                  if (_listData.isEmpty) {
                    return _buildEmptyState();
                  }

                  return AnimatedList(
                    key: _listKey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    initialItemCount: _listData.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= _listData.length) {
                        return const SizedBox.shrink();
                      }
                      final item = _listData[index];
                      final isFirstInGroup = index == 0 ||
                          (item.isCompleted &&
                              !_listData[index - 1].isCompleted);
                      final isLastInGroup = index == _listData.length - 1 ||
                          (!item.isCompleted &&
                              _listData[index + 1].isCompleted);
                      final isFirstCompleted = item.isCompleted &&
                          (index == 0 || !_listData[index - 1].isCompleted);

                      return _buildItem(
                        item,
                        animation,
                        isFirstInGroup: isFirstInGroup,
                        isLastInGroup: isLastInGroup,
                        isFirstCompleted: isFirstCompleted,
                      );
                    },
                  );
                } else if (state is TripDetailsError) {
                  return Center(
                      child: Text(context.loc.tripDetailsError(state.message)));
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? null
                    : FloatingActionButton(
                        onPressed: () {
                          final state = _tripDetailsBloc.state;
                          final title = state is TripDetailsLoaded
                              ? state.trip.title
                              : context.loc.untitledTrip;
                          _showAddItemsBottomSheet(context, title);
                        },
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.add),
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Text(context.loc.noItemsInTrip));
  }

  Widget _buildItem(TripDetailItem item, Animation<double> animation,
      {required bool isFirstInGroup,
      required bool isLastInGroup,
      bool isFirstCompleted = false}) {
    final theme = Theme.of(context);
    final isCompleted = item.isCompleted;

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: EdgeInsets.only(top: isFirstCompleted ? 32.0 : 0.0),
          child: AppSwipeableCard(
            key: ValueKey(item.item.id),
            margin: EdgeInsets.zero,
            onDelete: () {
              _tripDetailsBloc.add(RemoveTripItem(item.item.id));
            },
            actions: [
              SwipeAction(
                icon: Icons.delete_outline,
                color: Colors.red,
                label: context.loc.removeAction,
                onTap: () {
                  _tripDetailsBloc.add(RemoveTripItem(item.item.id));
                },
              ),
            ],
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.vertical(
                  top: isFirstInGroup ? const Radius.circular(8) : Radius.zero,
                  bottom:
                      isLastInGroup ? const Radius.circular(8) : Radius.zero,
                ),
                border: Border(
                  top: isFirstInGroup
                      ? BorderSide(color: Colors.grey.withValues(alpha: 0.3))
                      : BorderSide.none,
                  bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  left: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  right: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                title: Text(
                  item.item.title,
                  style: isCompleted
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade600)
                      : theme.textTheme.bodyLarge,
                ),
                trailing: Checkbox.adaptive(
                  value: isCompleted,
                  onChanged: (value) {
                    _tripDetailsBloc
                        .add(ToggleTripItemCompletion(item.item.id));
                  },
                ),
                onTap: () {
                  _tripDetailsBloc.add(ToggleTripItemCompletion(item.item.id));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddItemsBottomSheet(BuildContext context, String tripTitle) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
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
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      height: 5,
                      width: 40,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.addItemsTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            onPressed: () {
                              _tripDetailsBloc
                                  .add(LoadTripDetails(widget.tripId));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    Expanded(
                      child: BlocBuilder<TripItemSelectorBloc,
                          TripItemSelectorState>(
                        builder: (context, state) {
                          if (state is TripItemSelectorLoaded) {
                            final displayItems = state.filteredAvailableItems;
                            if (displayItems.isEmpty) {
                              return Center(
                                child: Text(
                                  context.loc.noItemsAvailableToAdd,
                                  style: TextStyle(
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                ),
                              );
                            }
                            return ListView.separated(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              itemCount: displayItems.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                              itemBuilder: (context, index) {
                                final item = displayItems[index];
                                final isSelected =
                                    state.selectedItemIds.contains(item.id);

                                return SwitchListTile.adaptive(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  value: isSelected,
                                  activeColor: theme.colorScheme.primary,
                                  title: _HighlightedText(
                                    text: item.title,
                                    query: state.searchQuery,
                                    highlightColor: theme.colorScheme.primary,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: item.description.isNotEmpty
                                      ? Text(item.description)
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onChanged: (bool value) {
                                    context.read<TripItemSelectorBloc>().add(
                                          ToggleItemSelection(item.id, value),
                                        );
                                  },
                                );
                              },
                            );
                          } else if (state is TripItemSelectorError) {
                            return Center(
                                child: Text(context.loc
                                    .tripDetailsError(state.message)));
                          }
                          return const Center(child: AdaptiveSpinner());
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: _AddItemsSearchBar(
                        onCreateNewItem: () => _showCreateItemDialog(context),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      _tripDetailsBloc.add(LoadTripDetails(widget.tripId));
    });
  }

  void _showCreateItemDialog(BuildContext parentContext) {
    final bloc = BlocProvider.of<TripItemSelectorBloc>(parentContext);
    final TextEditingController nameController = TextEditingController();
    String? errorMessage;

    showAdaptiveDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AdaptiveAlertDialog(
              title: Text(parentContext.loc.createNewItem),
              content: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: nameController,
                  onChanged: (val) {
                    if (errorMessage != null) {
                      setState(() {
                        errorMessage = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: parentContext.loc.itemNameLabel,
                    hintText: parentContext.loc.itemNameHint,
                    errorText: errorMessage,
                  ),
                  autofocus: true,
                ),
              ),
              actions: [
                AdaptiveDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(parentContext.loc.cancelButton),
                ),
                AdaptiveDialogAction(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final currentState = bloc.state;
                    if (name.isNotEmpty) {
                      if (currentState is TripItemSelectorLoaded) {
                        final lowerName = name.toLowerCase();
                        final exists = currentState.availableItems
                            .any((e) => e.title.toLowerCase() == lowerName);
                        if (exists) {
                          setState(() {
                            errorMessage = parentContext.loc.itemAlreadyExistsError;
                          });
                          return;
                        }
                      }
                      bloc.add(CreateAndSelectNewItem(name));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(parentContext.loc.createButton),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCongratulationsDialog() {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AdaptiveAlertDialog(
        title: Text(context.loc.congratulationsTitle),
        content: Text(context.loc.congratulationsMessage),
        actions: [
          AdaptiveDialogAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showClearAllButton = true;
              });
            },
            child: Text(context.loc.okButton),
          ),
        ],
      ),
    );
  }
}

class _AddItemsSearchBar extends StatefulWidget {
  final VoidCallback onCreateNewItem;

  const _AddItemsSearchBar({required this.onCreateNewItem});

  @override
  State<_AddItemsSearchBar> createState() => _AddItemsSearchBarState();
}

class _AddItemsSearchBarState extends State<_AddItemsSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocusedOrHasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(_updateState);
    _focusNode.addListener(_updateState);
  }

  void _updateState() {
    final isFocused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;
    bool shouldBeFocusedOrHasText = isFocused || hasText;

    if (_isFocusedOrHasText != shouldBeFocusedOrHasText) {
      setState(() {
        _isFocusedOrHasText = shouldBeFocusedOrHasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _focusNode.removeListener(_updateState);
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
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
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
                    decoration: InputDecoration(
                      hintText: context.loc.searchHint,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      context
                          .read<TripItemSelectorBloc>()
                          .add(SearchQueryChanged(val));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (_isFocusedOrHasText)
          InkWell(
            key: const ValueKey('search_cancel_btn'),
            onTap: () {
              if (_controller.text.isNotEmpty) {
                _controller.clear();
                context
                    .read<TripItemSelectorBloc>()
                    .add(SearchQueryChanged(''));
              } else {
                _focusNode.unfocus();
              }
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
            ),
          )
        else
          InkWell(
            key: const ValueKey('create_item_btn'),
            onTap: widget.onCreateNewItem,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.add, color: theme.colorScheme.primary),
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
            ) ??
            TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      // Important to set maxLines and overflow similar to a standard list title
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
