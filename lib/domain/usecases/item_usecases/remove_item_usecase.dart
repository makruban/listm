import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/value_objects/item_id.dart';

/// Use case for removing an item from the repository.
class RemoveItemUseCase extends UseCase<void, ItemId> {
  final ItemRepository repository;

  RemoveItemUseCase(this.repository);

  @override

  /// Calls the repository to remove the item by its ID.
  Future<void> call(ItemId id) async {
    await repository.deleteItem(id);
  }
}
