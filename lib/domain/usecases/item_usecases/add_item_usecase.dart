import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';

/// Use case for adding an item to the repository.
class AddItemUseCase extends UseCase<void, ItemEntity> {
  final ItemRepository repository;

  AddItemUseCase(this.repository);

  @override

  /// Calls the repository to add the item.
  Future<void> call(ItemEntity item) async {
    await repository.addItem(item);
  }
}
