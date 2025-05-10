import 'package:listm/data/repositories/item_repository.dart';
import 'package:listm/domain/entities/item_entity.dart';

class UpdateItemUseCase {
  final ItemRepository repository;

  UpdateItemUseCase(this.repository);

  Future<void> execute(ItemEntity item) async {
    await repository.updateItem(item);
  }
}
