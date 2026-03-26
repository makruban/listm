import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripwise/core/di/injection.dart';
import 'package:tripwise/presentation/bloc/app/app_bloc.dart';
import 'package:tripwise/presentation/bloc/app/app_event.dart';
import 'package:tripwise/presentation/bloc/item/items_bloc.dart';
import 'package:tripwise/presentation/bloc/trip/trips_bloc.dart';
import 'package:tripwise/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:tripwise/presentation/cubit/navigation_cubit.dart';
import 'package:tripwise/presentation/bloc/settings/settings_bloc.dart';

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
        BlocProvider(
            create: (_) => getIt<SettingsBloc>()..add(const LoadSettings())),
        // …add more providers here…
      ],
      child: child,
    );
  }
}
