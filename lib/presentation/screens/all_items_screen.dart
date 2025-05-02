import 'package:flutter/material.dart';
import '../widgets/item_tile.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Items'),
      ),
      body: const Center(
        child: Text('All Items Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add item functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
