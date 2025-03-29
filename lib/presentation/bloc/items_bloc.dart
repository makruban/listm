import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart';

// Events
abstract class ItemsEvent {}

class LoadItems extends ItemsEvent {}

class AddItem extends ItemsEvent {
  final Item item;
  AddItem(this.item);
}

// States
abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;
  ItemsLoaded(this.items);
}

// Bloc
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemsBloc() : super(ItemsInitial()) {
    on<LoadItems>((event, emit) {
      // Implementation
    });

    on<AddItem>((event, emit) {
      // Implementation
    });
  }
}
