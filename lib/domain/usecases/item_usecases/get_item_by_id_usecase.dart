import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/value_objects/item_id.dart';

/// Use case for retrieving an item by its ID from the repository.
class GetItemByIdUsecase extends UseCase<ItemEntity, ItemId> {
  final ItemRepository _itemRepository;

  GetItemByIdUsecase(this._itemRepository);

  @override
  Future<ItemEntity> call(ItemId id) async {
    return await _itemRepository.getItemById(id);
  }
}
