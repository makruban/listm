import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/di/injection.dart';
import 'package:listm/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';

class MaterialTripDetailScreen extends StatefulWidget {
  final String tripId;

  const MaterialTripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<MaterialTripDetailScreen> createState() =>
      _MaterialTripDetailScreenState();
}

class _MaterialTripDetailScreenState extends State<MaterialTripDetailScreen> {
  late TripDetailsBloc _tripDetailsBloc;

  @override
  void initState() {
    super.initState();
    _tripDetailsBloc = getIt<TripDetailsBloc>();
    _tripDetailsBloc.add(LoadTripDetails(widget.tripId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _tripDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TripDetailsBloc, TripDetailsState>(
            builder: (context, state) {
              if (state is TripDetailsLoaded) {
                return Text(state.trip.title);
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
                      // TODO: Implement remove item from trip
                    },
                    actions: [
                      SwipeAction(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        label: 'Remove',
                        onTap: () {
                          // TODO: Implement remove item from trip
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
            // TODO: Implement add item to trip
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
