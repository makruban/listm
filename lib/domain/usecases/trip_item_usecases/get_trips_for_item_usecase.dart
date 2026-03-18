import 'package:listm/core/usecases/usecase.dart';
import 'package:listm/domain/repositories/trip_item_relation_repository.dart';

class GetTripsForItemUseCase extends UseCase<List<String>, String> {
  final TripItemRelationRepository relationRepository;

  GetTripsForItemUseCase(this.relationRepository);

  @override
  Future<List<String>> call(String itemId) async {
    return relationRepository.getTripsForItem(itemId);
  }
}
