import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/domain/value_objects/trip_id.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/screens/packing_list_screen/widgets/packing_lists_view.dart';
import 'package:listm/presentation/widgets/app_swipeable_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Material-styled Packing Lists screen that listens to [TripsBloc]
/// and displays a list of trips, handling loading, empty, and error states.
class MaterialPackingListsScreen extends StatefulWidget {
  const MaterialPackingListsScreen({
    super.key,
    required this.tripsBloc,
  });
  final TripsBloc tripsBloc;

  @override
  State<MaterialPackingListsScreen> createState() =>
      _MaterialPackingListsScreenState();
}

class _MaterialPackingListsScreenState
    extends State<MaterialPackingListsScreen> {
  late TripsBloc _tripsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _tripsBloc = widget.tripsBloc;
    _tripsBloc.add(const LoadTrips());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
// Handle case where localizations might not be available
    if (loc == null) {
      return const Center(child: Text('Localizations not available'));
    }
    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state) {
        if (state is TripsLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TripsLoadSuccess) {
          final trips = state.trips;
          if (trips.isEmpty) {
            return Center(
              child: Text(loc.noTripsMessage),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return _TripCard(
                key: ValueKey(trip.id),
                trip: trip,
                tripsBloc: _tripsBloc,
              );
            },
          );
        } else if (state is TripsFailure) {
          return Center(
            child: Text(loc.tripsLoadError(state.error)),
          );
        }
        // initial or other states
        return const SizedBox.shrink();
      },
    );
  }
}

/// Separate widget for a [TripEntity] card to improve readability and allow const optimizations.
///
class _TripCard extends StatelessWidget {
  final TripEntity trip;
  final Bloc tripsBloc;
  const _TripCard({
    super.key,
    required this.trip,
    required this.tripsBloc,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    // Handle missing localizations gracefully
    if (loc == null) {
      return const SizedBox.shrink();
    }

    return AppSwipeableCard(
      key: ValueKey(trip.id),
      margin: const EdgeInsets.symmetric(vertical: 6),
      onDelete: () {
        tripsBloc.add(RemoveTripEvent(TripId(trip.id)));
      },
      actions: [
        SwipeAction(
          icon: Icons.edit,
          color: Colors.blue,
          label: 'Rename',
          onTap: () {
            // TODO: handle rename action
          },
        ),
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
                    Text('Title: ${trip.title}'),
                    Text('ID: ${trip.id}'),
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
            tripsBloc.add(RemoveTripEvent(TripId(trip.id)));
          },
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: trip.icon.isNotEmpty
              ? Image.asset(trip.icon, width: 32, height: 32)
              : const Icon(Icons.card_travel),
          title: Text(trip.title.isEmpty ? loc.untitledTrip : trip.title),
          subtitle: Text(
            '${trip.itemCount} ${loc.itemsLabel}',
          ),
          onTap: () {
            // context.go('${AppRoutes.packingLists}/${trip.id}');
          },
        ),
      ),
    );
  }
}
