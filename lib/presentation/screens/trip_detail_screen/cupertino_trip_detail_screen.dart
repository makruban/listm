import 'package:flutter/cupertino.dart';

class CupertinoTripDetailScreen extends StatelessWidget {
  final String tripId;

  const CupertinoTripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Trip Details'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trip ID: $tripId'),
            const SizedBox(height: 16),
            const Text('Cupertino Implementation'),
          ],
        ),
      ),
    );
  }
}
