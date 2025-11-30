import 'package:get_it/get_it.dart';
import 'package:listm/core/resources/app_key_constants.dart';
import 'package:listm/data/datasources/trip_local_data_source.dart';
import 'package:listm/data/repositories/trip_repository_impl.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/repositories/trip_repository.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';
import 'package:listm/data/repositories/trip_item_relation_repository_impl.dart';
import 'package:listm/domain/usecases/item_usecases/add_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/remove_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_item_by_id_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/update_item_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/add_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/delete_all_trips_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/delete_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trips_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/update_trip_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/get_items_for_trip_usecase.dart';
import 'package:listm/presentation/bloc/item/items_bloc.dart';
import 'package:listm/presentation/bloc/trip/trips_bloc.dart';
import 'package:listm/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:listm/presentation/cubit/navigation_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listm/data/datasources/item_local_data_source.dart';
import 'package:listm/data/repositories/item_repository_impl.dart';

final GetIt getIt = GetIt.instance;

/// Call this at app startup to register all dependencies
Future<void> configureDependencies() async {
  // 1️⃣ Core / third-party
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{CacheKeys.items, CacheKeys.trips},
    ),
  );
  getIt.registerSingleton<SharedPreferencesWithCache>(prefs);

  // 2️⃣ Data sources
  getIt.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(prefsWithCache: prefs),
  );
  getIt.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(prefsWithCache: prefs),
  );

  // 3️⃣ Repositories
  getIt.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(localDataSource: getIt()),
  );
  // … TripRepositoryImpl …
  getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<TripItemRelationRepository>(
    () => TripItemRelationRepositoryImpl(),
  );

  // 4️⃣ Use-cases
  getIt.registerLazySingleton(
    () => GetItemsUsecase(getIt()),
  );
  getIt.registerLazySingleton(
    () => AddItemUseCase(getIt()),
  );
  // … all your other UseCases …
  getIt.registerLazySingleton(
    () => GetItemByIdUsecase(getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => RemoveItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetTripsUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetTripByIdUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => AddTripUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateTripUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteTripUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteAllTripsUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetItemsForTripUseCase(
      relationRepository: getIt(),
      itemRepository: getIt(),
    ),
  );

  // 5️⃣ Blocs / Cubits as factories (so you get a new instance each time)
  getIt.registerFactory(
    () => ItemsBloc(
      getItemByIdUsecase: getIt<GetItemByIdUsecase>(),
      getItemsUsecase: getIt<GetItemsUsecase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      updateItemUseCase: getIt<UpdateItemUseCase>(),
      removeItemUseCase: getIt<RemoveItemUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => TripsBloc(
      getTripsUseCase: getIt<GetTripsUseCase>(),
      getTripByIdUseCase: getIt<GetTripByIdUseCase>(),
      addTripUseCase: getIt<AddTripUseCase>(),
      updateTripUseCase: getIt<UpdateTripUseCase>(),
      deleteTripUseCase: getIt<DeleteTripUseCase>(),
      deleteAllTripsUseCase: getIt<DeleteAllTripsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => TripDetailsBloc(
      getTripByIdUseCase: getIt<GetTripByIdUseCase>(),
      getItemsForTripUseCase: getIt<GetItemsForTripUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => NavigationCubit(),
  );
}
