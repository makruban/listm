import '../../data/repositories/item_repository.dart';
import '../../data/models/item.dart';

class UpdateItemUseCase {
  final ItemRepository repository;

  UpdateItemUseCase(this.repository);

  Future<void> execute(Item item) async {
    await repository.updateItem(item);
  }
}
