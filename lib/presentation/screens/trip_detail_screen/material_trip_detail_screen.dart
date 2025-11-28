import 'package:flutter/material.dart';

class MaterialTripDetailScreen extends StatelessWidget {
  final String tripId;

  const MaterialTripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trip ID: $tripId'),
            const SizedBox(height: 16),
            const Text('Material Implementation'),
          ],
        ),
      ),
    );
  }
}
