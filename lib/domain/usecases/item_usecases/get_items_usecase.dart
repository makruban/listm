import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/value_objects/no_params.dart';

class GetItemsUsecase extends UseCase<List<ItemEntity>, NoParams> {
  final ItemRepository repository;

  GetItemsUsecase(this.repository);

  @override
  Future<List<ItemEntity>> call(NoParams params) async {
    return await repository.getItems();
  }
}
