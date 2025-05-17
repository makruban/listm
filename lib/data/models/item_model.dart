import 'dart:convert';

import 'package:listm/domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  ItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  /// Convert a domain entity into a data model
  factory ItemModel.fromEntity(ItemEntity entity) => ItemModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        isCompleted: entity.isCompleted,
      );

  /// Convert this model (which extends ItemEntity) back into a pure entity
  ItemEntity toEntity() => ItemEntity(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
  @override
  String toString() => jsonEncode(toJson());
}
