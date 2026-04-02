import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'adaptive_base.dart';

class AdaptiveSpinner extends AdaptiveWidget {
  const AdaptiveSpinner({super.key});

  @override
  Widget buildMaterial(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildCupertino(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator());
  }
}
