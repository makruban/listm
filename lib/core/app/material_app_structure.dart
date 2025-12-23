import 'package:flutter/material.dart';
import 'package:listm/core/resources/theme_manager/material_theme_manager.dart';
import 'package:listm/core/routes/app_router.dart';
import 'package:listm/l10n/app_localizations.dart';

class MaterialAppStructure extends StatelessWidget {
  const MaterialAppStructure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'ListM',
      theme: MaterialThemeManager.getMaterialAppTheme(),
      // ←–– these two hook go_router into Navigator 2.0
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}
