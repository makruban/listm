import 'package:get_it/get_it.dart';
import 'package:tripwise/core/resources/app_key_constants.dart';
import 'package:tripwise/data/datasources/trip_local_data_source.dart';
import 'package:tripwise/data/repositories/trip_repository_impl.dart';
import 'package:tripwise/domain/repositories/item_repository.dart';
import 'package:tripwise/domain/repositories/trip_repository.dart';
import 'package:tripwise/domain/repositories/trip_item_relation_repository.dart';
import 'package:tripwise/data/repositories/trip_item_relation_repository_impl.dart';
import 'package:tripwise/data/datasources/trip_item_relation_local_data_source.dart';
import 'package:tripwise/domain/repositories/onboarding_repository.dart';
import 'package:tripwise/data/repositories/onboarding_repository_impl.dart';
import 'package:tripwise/domain/usecases/item_usecases/add_item_usecase.dart';
import 'package:tripwise/domain/usecases/item_usecases/remove_item_usecase.dart';
import 'package:tripwise/domain/usecases/item_usecases/get_items_usecase.dart';
import 'package:tripwise/domain/usecases/item_usecases/get_item_by_id_usecase.dart';
import 'package:tripwise/domain/usecases/item_usecases/update_item_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/add_trip_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/delete_all_trips_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/delete_trip_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/get_trip_by_id_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/get_trips_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/update_trip_usecase.dart';
import 'package:tripwise/domain/usecases/trip_usecases/get_trips_stream_usecase.dart';
import 'package:tripwise/domain/usecases/trip_item_usecases/get_items_for_trip_usecase.dart';
import 'package:tripwise/domain/usecases/trip_item_usecases/add_trip_item_usecase.dart';
import 'package:tripwise/domain/usecases/trip_item_usecases/remove_trip_item_usecase.dart';
import 'package:tripwise/domain/usecases/trip_item_usecases/toggle_trip_item_completion_usecase.dart';
import 'package:tripwise/domain/usecases/trip_item_usecases/get_trips_for_item_usecase.dart';
import 'package:tripwise/domain/usecases/item_usecases/get_items_stream_usecase.dart';
import 'package:tripwise/domain/usecases/onboarding_usecases/check_onboarding_status_usecase.dart';
import 'package:tripwise/domain/usecases/onboarding_usecases/complete_onboarding_usecase.dart';
import 'package:tripwise/presentation/bloc/app/app_bloc.dart';
import 'package:tripwise/presentation/bloc/item/items_bloc.dart';
import 'package:tripwise/presentation/bloc/trip/trips_bloc.dart';
import 'package:tripwise/presentation/bloc/trip_details/trip_details_bloc.dart';
import 'package:tripwise/presentation/bloc/trip_item_selector/trip_item_selector_bloc.dart';
import 'package:tripwise/presentation/cubit/navigation_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripwise/data/datasources/item_local_data_source.dart';
import 'package:tripwise/data/repositories/item_repository_impl.dart';
import 'package:tripwise/data/datasources/app_settings_local_data_source.dart';
import 'package:tripwise/data/repositories/app_settings_repository_impl.dart';
import 'package:tripwise/domain/repositories/app_settings_repository.dart';
import 'package:tripwise/domain/usecases/app_settings_usecases/get_app_settings_usecase.dart';
import 'package:tripwise/domain/usecases/app_settings_usecases/save_app_settings_usecase.dart';
import 'package:tripwise/presentation/bloc/settings/settings_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Call this at app startup to register all dependencies
Future<void> configureDependencies() async {
  // 1️⃣ Core / third-party
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{
        CacheKeys.items,
        CacheKeys.trips,
        CacheKeys.tripItemRelations,
        CacheKeys.hasSeenOnboarding,
        CacheKeys.appSettings,
      },
    ),
  );
  getIt.registerSingleton<SharedPreferencesWithCache>(prefs);

  // 2️⃣ Data sources
  getIt.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(prefsWithCache: prefs),
  );
  getIt.registerLazySingleton<AppSettingsLocalDataSource>(
    () => AppSettingsLocalDataSourceImpl(prefsWithCache: prefs),
  );
  getIt.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(prefsWithCache: prefs),
  );

  // 3️⃣ Repositories
  getIt.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<AppSettingsRepository>(
    () => AppSettingsRepositoryImpl(localDataSource: getIt()),
  );
  // … TripRepositoryImpl …
  getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<TripItemRelationLocalDataSource>(
    () => TripItemRelationLocalDataSourceImpl(prefsWithCache: prefs),
  );
  getIt.registerLazySingleton<TripItemRelationRepository>(
    () => TripItemRelationRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(prefsWithCache: prefs),
  );

  // 4️⃣ Use-cases
  getIt.registerLazySingleton(
    () => GetItemsUsecase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAppSettingsUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => SaveAppSettingsUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => AddItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetItemsStreamUseCase(getIt()),
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
    () => GetTripsStreamUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetItemsForTripUseCase(
      relationRepository: getIt(),
      itemRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddTripItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => RemoveTripItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => ToggleTripItemCompletionUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetTripsForItemUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => CheckOnboardingStatusUseCase(getIt()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboardingUseCase(getIt()),
  );

  // 5️⃣ Blocs / Cubits as factories (so you get a new instance each time)
  getIt.registerFactory(
    () => AppBloc(
      checkOnboardingStatusUseCase: getIt<CheckOnboardingStatusUseCase>(),
      completeOnboardingUseCase: getIt<CompleteOnboardingUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => SettingsBloc(
      getAppSettingsUseCase: getIt<GetAppSettingsUseCase>(),
      saveAppSettingsUseCase: getIt<SaveAppSettingsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ItemsBloc(
      getItemByIdUsecase: getIt<GetItemByIdUsecase>(),
      getItemsUsecase: getIt<GetItemsUsecase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      updateItemUseCase: getIt<UpdateItemUseCase>(),
      removeItemUseCase: getIt<RemoveItemUseCase>(),
      getItemsStreamUseCase: getIt<GetItemsStreamUseCase>(),
      getTripsForItemUseCase: getIt<GetTripsForItemUseCase>(),
      getTripsUseCase: getIt<GetTripsUseCase>(),
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
      getTripsStreamUseCase: getIt<GetTripsStreamUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => TripDetailsBloc(
      getTripByIdUseCase: getIt<GetTripByIdUseCase>(),
      getItemsForTripUseCase: getIt<GetItemsForTripUseCase>(),
      getItemsUsecase: getIt<GetItemsUsecase>(),
      addTripItemUseCase: getIt<AddTripItemUseCase>(),
      removeTripItemUseCase: getIt<RemoveTripItemUseCase>(),
      updateTripUseCase: getIt<UpdateTripUseCase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      getItemsStreamUseCase: getIt<GetItemsStreamUseCase>(),
      toggleTripItemCompletionUseCase: getIt<ToggleTripItemCompletionUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => TripItemSelectorBloc(
      getItemsStreamUseCase: getIt<GetItemsStreamUseCase>(),
      getItemsForTripUseCase: getIt<GetItemsForTripUseCase>(),
      addTripItemUseCase: getIt<AddTripItemUseCase>(),
      removeTripItemUseCase: getIt<RemoveTripItemUseCase>(),
      addItemUseCase: getIt<AddItemUseCase>(),
      getItemsUseCase: getIt<GetItemsUsecase>(),
      getTripByIdUseCase: getIt<GetTripByIdUseCase>(),
      updateTripUseCase: getIt<UpdateTripUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => NavigationCubit(),
  );
}
