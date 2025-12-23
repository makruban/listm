import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'TripWise'**
  String get appTitle;

  /// Welcome message on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to TripWise'**
  String get welcome;

  /// Label for the Packing Lists tab
  ///
  /// In en, this message translates to:
  /// **'Packing Lists'**
  String get packingLists;

  /// Label for the All Items tab
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// Tooltip text for the FAB when on Packing Lists
  ///
  /// In en, this message translates to:
  /// **'Add Packing List'**
  String get addPackingList;

  /// Tooltip text for the FAB when on All Items
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// Message shown when there are no trips in the list
  ///
  /// In en, this message translates to:
  /// **'No packing lists found. Tap + to add one.'**
  String get noTripsMessage;

  /// Error message when trips fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load packing lists: {error}'**
  String tripsLoadError(Object error);

  /// Fallback title when a trip has no name
  ///
  /// In en, this message translates to:
  /// **'Untitled trip'**
  String get untitledTrip;

  /// Label for the number of items in a trip
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemsLabel;

  /// Label for rename action in swipe menu
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameAction;

  /// Label for info action in swipe menu
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoAction;

  /// Label for delete action in swipe menu
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Title for trip details dialog
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetailsTitle;

  /// Label showing trip title in dialog
  ///
  /// In en, this message translates to:
  /// **'Title: {title}'**
  String tripTitleLabel(Object title);

  /// Label showing trip ID in dialog
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String tripIdLabel(Object id);

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Label for remove action
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
