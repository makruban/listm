import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/di/injection.dart';
import 'package:listm/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';

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
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocConsumer<TripDetailsBloc, TripDetailsState>(
              listener: (context, state) {
                if (state is TripDetailsLoaded) {
                  // Only set text if not focused to avoid overwriting user input while typing
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
                            .withOpacity(0.7),
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
          body: BlocBuilder<TripDetailsBloc, TripDetailsState>(
            builder: (context, state) {
              if (state is TripDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TripDetailsLoaded) {
                if (state.items.isEmpty) {
                  return const Center(child: Text('No items in this trip'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return AppSwipeableCard(
                      key: ValueKey(item.id),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      onDelete: () {
                        _tripDetailsBloc.add(RemoveTripItem(item.id));
                      },
                      actions: [
                        SwipeAction(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          label: 'Remove',
                          onTap: () {
                            _tripDetailsBloc.add(RemoveTripItem(item.id));
                          },
                        ),
                      ],
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.description),
                          trailing: Checkbox(
                            value: item.isCompleted,
                            onChanged: (value) {
                              // TODO: Implement toggle completion
                            },
                          ),
                        ),
                      ),
                    );
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
    );
  }

  void _showAddItemsBottomSheet(BuildContext context) {
    _tripDetailsBloc.add(LoadAvailableItems());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider.value(
          value: _tripDetailsBloc,
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
                      builder: (context, state) {
                        if (state is TripDetailsLoaded) {
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
                              // Check if item is already in the trip
                              final isAlreadyAdded = state.items.any(
                                (tripItem) => tripItem.id == item.id,
                              );

                              return CheckboxListTile(
                                value: isAlreadyAdded,
                                title: Text(item.title),
                                subtitle: Text(item.description),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    _tripDetailsBloc.add(AddTripItem(item.id));
                                  } else {
                                    _tripDetailsBloc
                                        .add(RemoveTripItem(item.id));
                                  }
                                },
                              );
                            },
                          );
                        } else if (state is TripDetailsError) {
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
    );
  }
}
