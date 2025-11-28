import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:listm/presentation/screens/trip_detail_screen/cupertino_trip_detail_screen.dart';
import 'package:listm/presentation/screens/trip_detail_screen/material_trip_detail_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;

  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTripDetailScreen(tripId: tripId)
        : MaterialTripDetailScreen(tripId: tripId);
  }
}
