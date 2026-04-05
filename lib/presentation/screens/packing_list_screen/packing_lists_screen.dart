import 'dart:math' as math;
import 'package:flutter/material.dart' hide showAdaptiveDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripwise/domain/entities/trip_entity.dart';
import 'package:tripwise/domain/value_objects/trip_id.dart';
import 'package:tripwise/core/widgets/adaptive/adaptive_spinner.dart';
import 'package:tripwise/presentation/bloc/trip/trips_bloc.dart';
import 'package:tripwise/presentation/widgets/app_swipeable_card.dart';
import 'package:tripwise/presentation/widgets/suitcase_painter.dart';
import 'package:tripwise/presentation/screens/packing_list_screen/widgets/trip_progress_indicator.dart';
import 'package:tripwise/presentation/screens/packing_list_screen/widgets/simple_suitcase_icon.dart';
import 'package:tripwise/core/util/build_context_ext.dart';

/// Material-styled Packing Lists screen that listens to [TripsBloc]
/// and displays a list of trips, handling loading, empty, and error states.
class PackingListsScreen extends StatefulWidget {
  const PackingListsScreen({
    super.key,
    required this.tripsBloc,
  });
  final TripsBloc tripsBloc;

  @override
  State<PackingListsScreen> createState() => _PackingListsScreenState();
}

class _PackingListsScreenState extends State<PackingListsScreen>
    with SingleTickerProviderStateMixin {
  late TripsBloc _tripsBloc;
  late AnimationController _arrowController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _tripsBloc = widget.tripsBloc;
    // Animation for the arrow shimmer
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state) {
        if (state is TripsLoadInProgress) {
          return const Center(child: AdaptiveSpinner());
        } else if (state is TripsLoadSuccess) {
          final trips = state.trips;
          if (trips.isEmpty) {
            return _PackingListEmptyState(
              arrowController: _arrowController,
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
    final loc = context.loc;

    return AppSwipeableCard(
      key: ValueKey(trip.id),
      margin: const EdgeInsets.symmetric(vertical: 6),
      onDelete: _handleDeleteTrip,
      actions: [
        SwipeAction(
          icon: Icons.delete_outline,
          color: Colors.red,
          label: loc.deleteAction,
          onTap: _handleDeleteTrip,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark 
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 15,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.06), // Light subtle glow
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
          ],
          border: theme.brightness == Brightness.dark
              ? Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _navigateToTripDetails(context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF3F8), // Restoring original soft rounded background
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: trip.icon.isNotEmpty
                        ? Image.asset(trip.icon, width: 36, height: 36)
                        : const SimpleSuitcaseIcon(size: 44),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title.isEmpty ? loc.untitledTrip : trip.title,
                          style: titleTextStyle?.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${trip.itemCount} ${loc.itemsLabel}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trip.itemCount > 0) ...[
                    const SizedBox(width: 12),
                    TripProgressIndicator(
                      size:
                          60, // Exact match with the suitcase container width/height
                      progress: trip.completedItemCount / trip.itemCount,
                      progressColor:
                          const Color(0xFF2CB567), // Vibrant modern green
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PackingListEmptyState extends StatelessWidget {
  const _PackingListEmptyState({
    required this.arrowController,
  });
  final AnimationController arrowController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.loc;

    final mainMessage = loc.noTripsMessageTitle;
    final subMessage = loc.noTripsMessageSub;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated floating suitcase
            AnimatedBuilder(
              animation: arrowController,
              builder: (context, child) {
                // Use a sine wave for smooth floating up and down
                final offsetY =
                    math.sin(arrowController.value * 2 * math.pi) * 8.0;

                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: child,
                );
              },
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 160,
                    height: 200,
                    child: CustomPaint(
                      painter: SuitcasePainter(
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              mainMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 80), // Space to avoid arrow overlap
          ],
        ),
      ),
    );
  }
}
