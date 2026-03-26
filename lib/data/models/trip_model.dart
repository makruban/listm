import 'dart:convert';

import 'package:tripwise/domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  TripModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.itemCount,
    super.completedItemCount = 0,
  });
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      itemCount: json['itemCount'] as int,
      completedItemCount: (json['completedItemCount'] as int?) ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'itemCount': itemCount,
        'completedItemCount': completedItemCount,
      };

  /// Convert a domain entity into a data model
  factory TripModel.fromEntity(TripEntity entity) => TripModel(
        id: entity.id,
        title: entity.title,
        icon: entity.icon,
        itemCount: entity.itemCount,
        completedItemCount: entity.completedItemCount,
      );

  /// Convert this model (which extends ItemEntity) back into a pure entity
  TripEntity toEntity() => TripEntity(
        id: id,
        title: title,
        icon: icon,
        itemCount: itemCount,
        completedItemCount: completedItemCount,
      );

  @override
  String toString() => jsonEncode(toJson());
  @override
  List<Object?> get props => [id, title, icon, itemCount, completedItemCount];
  @override
  bool? get stringify => true;
  @override
  String get id => super.id;
}
