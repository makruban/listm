import 'package:flutter/material.dart';

class PackingListsScreen extends StatelessWidget {
  const PackingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing Lists'),
      ),
      body: const Center(
        child: Text('Packing Lists Screen'),
      ),
    );
  }
}
