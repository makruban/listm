import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemTile({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
      onTap: onTap,
    );
  }
}
