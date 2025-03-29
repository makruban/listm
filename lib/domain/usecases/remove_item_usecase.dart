import '../../data/repositories/item_repository.dart';

class RemoveItemUseCase {
  final ItemRepository repository;

  RemoveItemUseCase(this.repository);

  Future<void> execute(String id) async {
    await repository.removeItem(id);
  }
}
