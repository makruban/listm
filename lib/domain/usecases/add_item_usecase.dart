import '../../data/repositories/item_repository.dart';
import '../../data/models/item.dart';

class AddItemUseCase {
  final ItemRepository repository;

  AddItemUseCase(this.repository);

  Future<void> execute(Item item) async {
    await repository.addItem(item);
  }
}
