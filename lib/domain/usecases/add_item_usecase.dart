import 'package:listm/data/repositories/item_repository.dart';
import 'package:listm/domain/entities/item_entity.dart';

class AddItemUseCase {
  final ItemRepository repository;

  AddItemUseCase(this.repository);

  Future<void> execute(ItemEntity item) async {
    await repository.addItem(item);
  }
}
