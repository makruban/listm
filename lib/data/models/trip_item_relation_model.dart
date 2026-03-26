import 'package:tripwise/domain/entities/trip_item_relation_entity.dart';

class TripItemRelationModel extends TripItemRelationEntity {
  const TripItemRelationModel({
    required super.tripId,
    required super.itemId,
    super.isCompleted,
  });

  factory TripItemRelationModel.fromJson(Map<String, dynamic> json) {
    return TripItemRelationModel(
      tripId: json['tripId'] as String,
      itemId: json['itemId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'itemId': itemId,
      'isCompleted': isCompleted,
    };
  }

  factory TripItemRelationModel.fromEntity(TripItemRelationEntity entity) {
    return TripItemRelationModel(
      tripId: entity.tripId,
      itemId: entity.itemId,
      isCompleted: entity.isCompleted,
    );
  }
}
