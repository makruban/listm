import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/util/unique_id_service.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/usecases/item_usecases/add_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_item_by_id_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/remove_item_usecase.dart';
import 'package:listm/domain/usecases/item_usecases/update_item_usecase.dart';
import 'package:listm/domain/value_objects/item_id.dart';
import 'dart:async';
import 'package:listm/domain/value_objects/item_id.dart';
import 'package:listm/domain/value_objects/no_params.dart';
import 'package:listm/domain/usecases/item_usecases/get_items_stream_usecase.dart';
import 'package:listm/domain/usecases/trip_item_usecases/get_trips_for_item_usecase.dart';
import 'package:listm/domain/usecases/trip_usecases/get_trips_usecase.dart';
import 'package:listm/presentation/bloc/item/item_view_model.dart';
part 'items_event.dart';
part 'items_state.dart';

/// Business Logic Component for managing ItemEntity objects.
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final GetItemsUsecase _getItemsUsecase;
  final GetItemByIdUsecase _getItemByIdUsecase;
  final AddItemUseCase _addItemUseCase;
  final UpdateItemUseCase _updateItemUseCase;
  final RemoveItemUseCase _removeItemUseCase;
  final GetItemsStreamUseCase _getItemsStreamUseCase;
  final GetTripsForItemUseCase _getTripsForItemUseCase;
  final GetTripsUseCase _getTripsUseCase;
  StreamSubscription<List<ItemEntity>>? _itemsSubscription;

  ItemsBloc({
    required GetItemsUsecase getItemsUsecase,
    required GetItemByIdUsecase getItemByIdUsecase,
    required AddItemUseCase addItemUseCase,
    required UpdateItemUseCase updateItemUseCase,
    required RemoveItemUseCase removeItemUseCase,
    required GetItemsStreamUseCase getItemsStreamUseCase,
    required GetTripsForItemUseCase getTripsForItemUseCase,
    required GetTripsUseCase getTripsUseCase,
  })  : _getItemsUsecase = getItemsUsecase,
        _getItemByIdUsecase = getItemByIdUsecase,
        _addItemUseCase = addItemUseCase,
        _updateItemUseCase = updateItemUseCase,
        _removeItemUseCase = removeItemUseCase,
        _getItemsStreamUseCase = getItemsStreamUseCase,
        _getTripsForItemUseCase = getTripsForItemUseCase,
        _getTripsUseCase = getTripsUseCase,
        super(const ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<ItemsUpdated>(_onItemsUpdated);
    on<GetItemByIdEvent>(_onGetItemById);
    on<AddItemEvent>(_onAddItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<RemoveItemEvent>(_onRemoveItem);

    _subscribeToItems();
  }

  void _subscribeToItems() async {
    final stream = await _getItemsStreamUseCase(const NoParams());
    _itemsSubscription = stream.listen((items) {
      add(ItemsUpdated(items));
    });
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }

  Future<List<ItemViewModel>> _computeTripNames(List<ItemEntity> items) async {
    final trips = await _getTripsUseCase(const NoParams());
    final Map<String, String> tripTitleMap = {
      for (var trip in trips) trip.id: trip.title
    };

    final List<ItemViewModel> itemViewModels = [];
    for (var item in items) {
      final tripIds = await _getTripsForItemUseCase(item.id);
      final tripNames = tripIds.map((id) => tripTitleMap[id] ?? 'Unknown Trip').toList();
      itemViewModels.add(ItemViewModel(item: item, tripNames: tripNames));
    }
    return itemViewModels;
  }

  Future<void> _onItemsUpdated(ItemsUpdated event, Emitter<ItemsState> emit) async {
    final viewModels = await _computeTripNames(event.items);
    emit(ItemsLoadSuccess(viewModels));
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    emit(const ItemsLoadInProgress());
    try {
      final items = await _getItemsUsecase(const NoParams());
      final viewModels = await _computeTripNames(items);
      emit(ItemsLoadSuccess(viewModels));
    } catch (e) {
      emit(ItemsFailure(e.toString()));
    }
  }

  Future<void> _onGetItemById(
      GetItemByIdEvent event, Emitter<ItemsState> emit) async {
    emit(const ItemsLoadInProgress());
    try {
      final item = await _getItemByIdUsecase(event.id);
      emit(ItemLoadSuccess(item));
    } catch (e) {
      emit(ItemsFailure(e.toString()));
    }
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemsState> emit) async {
    try {
      final String title = event.name ?? '';
      final ItemEntity item = ItemEntity(
        id: await UniqueIdService.instance.generateItemId(
          strategy: IdGenerationStrategy.uuid,
        ),
        title: title,
        description: '',
      );
      await _addItemUseCase(item);
      // No need to reload, stream will update
    } catch (e) {
      emit(ItemsFailure(e.toString()));
    }
  }

  Future<void> _onUpdateItem(
      UpdateItemEvent event, Emitter<ItemsState> emit) async {
    try {
      await _updateItemUseCase(event.item);
      // No need to reload, stream will update
    } catch (e) {
      emit(ItemsFailure(e.toString()));
    }
  }

  Future<void> _onRemoveItem(
      RemoveItemEvent event, Emitter<ItemsState> emit) async {
    try {
      await _removeItemUseCase(event.id);
      // No need to reload, stream will update
    } catch (e) {
      emit(ItemsFailure(e.toString()));
    }
  }
}
