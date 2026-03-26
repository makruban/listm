import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/repositories/item_repository.dart';
import 'package:tripwise/domain/value_objects/item_id.dart';

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
