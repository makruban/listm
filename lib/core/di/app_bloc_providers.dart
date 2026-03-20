import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/di/injection.dart';
import 'package:listm/presentation/bloc/app/app_bloc.dart';
import 'package:listm/presentation/bloc/app/app_event.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;

  const AppBlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Blocs as factories so each use gets a fresh instance:
        BlocProvider(create: (_) => getIt<AppBloc>()..add(const AppStarted())),
        BlocProvider(create: (_) => getIt<ItemsBloc>()..add(const LoadItems())),
        BlocProvider(create: (_) => getIt<TripsBloc>()..add(const LoadTrips())),
        BlocProvider(create: (_) => getIt<NavigationCubit>()),
        BlocProvider(create: (_) => getIt<TripDetailsBloc>()),
        // …add more providers here…
      ],
      child: child,
    );
  }
}
