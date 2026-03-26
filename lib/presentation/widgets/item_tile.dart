import 'package:flutter/material.dart';
import 'package:listm/domain/entities/item_entity.dart';

class ItemTile extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback? onTap;

  const ItemTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
      onTap: onTap,
    );
  }
}
