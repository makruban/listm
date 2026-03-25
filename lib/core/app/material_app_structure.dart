import 'package:flutter/material.dart';
import 'package:listm/core/resources/theme_manager/material_theme_manager.dart';
import 'package:listm/core/routes/app_router.dart';
import 'package:listm/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/presentation/bloc/settings/settings_bloc.dart';

class MaterialAppStructure extends StatelessWidget {
  const MaterialAppStructure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final langCode = state.settings.languageCode;
        final locale = langCode != null ? Locale(langCode) : null;
        return MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (deviceLocale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == deviceLocale.languageCode) {
                  return deviceLocale;
                }
              }
            }
            return const Locale('en');
          },
          title: 'TripWise',
          theme: MaterialThemeManager.getMaterialAppTheme(),
          routerDelegate: appRouter.routerDelegate,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
        );
      },
    );
  }
}
