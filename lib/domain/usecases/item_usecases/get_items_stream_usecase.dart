import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/entities/item_entity.dart';
import 'package:listm/domain/repositories/item_repository.dart';
import 'package:listm/domain/value_objects/no_params.dart';

class GetItemsStreamUseCase
    extends UseCase<Stream<List<ItemEntity>>, NoParams> {
  final ItemRepository repository;

  GetItemsStreamUseCase(this.repository);

  @override
  Future<Stream<List<ItemEntity>>> call(NoParams params) async {
    return repository.getItemsStream();
  }
}
