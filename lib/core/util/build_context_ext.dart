import 'package:flutter/widgets.dart';
import 'package:tripwise/l10n/app_localizations.dart';

extension LocalizationsExtension on BuildContext {
  /// Returns the context's AppLocalizations or safely falls back to English
  AppLocalizations get loc =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('en'));
}
