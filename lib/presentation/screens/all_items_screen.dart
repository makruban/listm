import 'package:flutter/material.dart';

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
    );
  }
}
