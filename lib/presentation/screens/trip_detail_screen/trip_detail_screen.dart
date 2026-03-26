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
import 'package:listm/core/util/build_context_ext.dart';

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showCreateItemDialog(context),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: theme.colorScheme.primary),
                                const SizedBox(width: 16),
                                Text(
                                  context.loc.createNewItem,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    Expanded(
                      child: BlocBuilder<TripItemSelectorBloc,
                          TripItemSelectorState>(
                        builder: (context, state) {
                          if (state is TripItemSelectorLoaded) {
                            if (state.availableItems.isEmpty) {
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
                              itemCount: state.availableItems.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                              itemBuilder: (context, index) {
                                final item = state.availableItems[index];
                                final isSelected =
                                    state.selectedItemIds.contains(item.id);

                                return SwitchListTile.adaptive(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  value: isSelected,
                                  activeColor: theme.colorScheme.primary,
                                  title: Text(
                                    item.title,
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

    showAdaptiveDialog(
      context: parentContext,
      builder: (context) {
        return AdaptiveAlertDialog(
          title: Text(context.loc.createNewItem),
          content: Material(
            color: Colors.transparent,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.loc.itemNameLabel,
                hintText: context.loc.itemNameHint,
              ),
              autofocus: true,
            ),
          ),
          actions: [
            AdaptiveDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.loc.cancelButton),
            ),
            AdaptiveDialogAction(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  bloc.add(CreateAndSelectNewItem(name));
                  Navigator.pop(context);
                }
              },
              child: Text(context.loc.createButton),
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
