import 'package:flutter/cupertino.dart';
import 'package:listm/presentation/screens/packing_list_screen/widgets/packing_lists_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CupertinoPackingListsScreen extends StatelessWidget {
  const CupertinoPackingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.packingLists),
      ),
      child: const SafeArea(child: const SizedBox()),
    );
  }
}
