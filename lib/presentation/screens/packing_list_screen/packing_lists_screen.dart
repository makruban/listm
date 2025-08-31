import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listm/presentation/screens/packing_list_screen/cupertino_packing_lists_screen.dart';
import 'package:listm/presentation/screens/packing_list_screen/material_packing_lists_screen.dart';

// /// Platform-aware entrypoint for the Packing Lists screen.
// /// Chooses Material or Cupertino scaffold based on OS.
// class PackingListsScreen extends StatelessWidget {
//   const PackingListsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Platform.isIOS
//         ? const CupertinoPackingListsScreen()
//         : const MaterialPackingListsScreen();
//   }
// }
