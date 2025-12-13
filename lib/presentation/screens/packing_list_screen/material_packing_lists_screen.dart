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

  void _navigateToTripDetails(BuildContext context) {
    context.goNamed(
      'tripDetail',
      pathParameters: {'id': trip.id},
    );
  }

  void _handleRenameAction() {
    // TODO: handle rename action
  }

  void _handleShowInfoDialog(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.tripDetailsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.tripTitleLabel(trip.title)),
            Text(loc.tripIdLabel(trip.id)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _handleCloseDialog(context),
            child: Text(loc.closeButton),
          ),
        ],
      ),
    );
  }

  void _handleDeleteTrip() {
    tripsBloc.add(RemoveTripEvent(TripId(trip.id)));
  }

  void _handleCloseDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? titleTextStyle = theme.textTheme.titleLarge;
    final loc = AppLocalizations.of(context);
    // Handle missing localizations gracefully
    if (loc == null) {
      return const SizedBox.shrink();
    }

    return AppSwipeableCard(
      key: ValueKey(trip.id),
      margin: const EdgeInsets.symmetric(vertical: 6),
      onDelete: _handleDeleteTrip,
      actions: [
        SwipeAction(
          icon: Icons.edit,
          color: Colors.blue,
          label: loc.renameAction,
          onTap: _handleRenameAction,
        ),
        SwipeAction(
          icon: Icons.info_outline,
          color: Colors.green,
          label: loc.infoAction,
          onTap: () => _handleShowInfoDialog(context),
        ),
        SwipeAction(
          icon: Icons.delete_outline,
          color: Colors.red,
          label: loc.deleteAction,
          onTap: _handleDeleteTrip,
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: trip.icon.isNotEmpty
              ? Image.asset(trip.icon, width: 32, height: 32)
              : const Icon(Icons.card_travel),
          title: Text(trip.title.isEmpty ? loc.untitledTrip : trip.title,
              style: titleTextStyle),
          subtitle: Text(
            '${trip.itemCount} ${loc.itemsLabel}',
            style: theme.textTheme.bodyLarge,
          ),
          onTap: () => _navigateToTripDetails(context),
        ),
      ),
    );
  }
}
