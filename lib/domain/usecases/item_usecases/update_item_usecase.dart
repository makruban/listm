import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';

/// Use case for updating an item in the repository.
class UpdateItemUseCase extends UseCase<void, ItemEntity> {
  final ItemRepository repository;

  UpdateItemUseCase(this.repository);

  @override

  /// Calls the repository to update the item.
  Future<void> call(ItemEntity item) async {
    await repository.updateItem(item);
  }
}
