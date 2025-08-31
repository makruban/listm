import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/domain/entities/trip_entity.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/screens/packing_list_screen/widgets/packing_lists_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Material-styled Packing Lists screen that listens to [TripsBloc]
/// and displays a list of trips, handling loading, empty, and error states.
class MaterialPackingListsScreen extends StatefulWidget {
  const MaterialPackingListsScreen({Key? key}) : super(key: key);

  @override
  State<MaterialPackingListsScreen> createState() =>
      _MaterialPackingListsScreenState();
}

class _MaterialPackingListsScreenState
    extends State<MaterialPackingListsScreen> {
  late TripsBloc _tripsBloc;
  // Guard to ensure we only load trips once
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _tripsBloc = context.read<TripsBloc>();
      // Trigger initial load of trips
      _tripsBloc.add(const LoadTrips());
      _isInitialized = true;
    }
  }

  @override
  void initState() {
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
              return _TripCard(key: ValueKey(trip.id), trip: trip);
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
  const _TripCard({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    // Handle missing localizations gracefully
    if (loc == null) {
      return const SizedBox.shrink();
    }
    return Card(
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
    );
  }
}
