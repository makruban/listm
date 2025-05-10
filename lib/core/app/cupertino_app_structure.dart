import 'package:flutter/cupertino.dart';
import 'package:listm/core/resources/theme_manager/cupertino_theme_manager.dart';
import 'package:listm/core/routes/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CupertinoAppStructure extends StatelessWidget {
  const CupertinoAppStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'ListM',
      theme: CupertinoThemeManager.getCupertinoAppTheme(),
      // ←–– these two hook go_router into Navigator 2.0
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}
