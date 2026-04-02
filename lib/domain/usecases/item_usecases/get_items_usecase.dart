import 'package:tripwise/core/usecases/usecase.dart';
import 'package:tripwise/domain/entities/item_entity.dart';
import 'package:tripwise/domain/repositories/item_repository.dart';
import 'package:tripwise/domain/value_objects/no_params.dart';

class GetItemsUsecase extends UseCase<List<ItemEntity>, NoParams> {
  final ItemRepository repository;

  GetItemsUsecase(this.repository);

  @override
  Future<List<ItemEntity>> call(NoParams params) async {
    return await repository.getItems();
  }
}
