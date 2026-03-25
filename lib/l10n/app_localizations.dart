import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_uk.dart';

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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('uk')
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

  /// Title for onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Plan your trips'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1Part1.
  ///
  /// In en, this message translates to:
  /// **'Create a trip by clicking the '**
  String get onboardingDesc1Part1;

  /// No description provided for @onboardingDesc1Part2.
  ///
  /// In en, this message translates to:
  /// **' button'**
  String get onboardingDesc1Part2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Never forget an item'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your items and ensure you have everything you need for your journey.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Ready for takeoff'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your trip with peace of mind knowing you are fully prepared.'**
  String get onboardingDesc3;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @noTripsMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'No packing lists found'**
  String get noTripsMessageTitle;

  /// No description provided for @noTripsMessageSub.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add one.'**
  String get noTripsMessageSub;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteItemConfirmation(Object title);

  /// No description provided for @itemUsedInTripsWarning.
  ///
  /// In en, this message translates to:
  /// **'Attention! This item is used in Trip(s):'**
  String get itemUsedInTripsWarning;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @itemsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String itemsLoadError(Object error);

  /// No description provided for @itemCounterLabel.
  ///
  /// In en, this message translates to:
  /// **'Item {index}'**
  String itemCounterLabel(Object index);

  /// No description provided for @itemDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemDetailsTitle;

  /// No description provided for @itemTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title: {title}'**
  String itemTitleLabel(Object title);

  /// No description provided for @itemIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String itemIdLabel(Object id);

  /// No description provided for @notPackedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not packed'**
  String get notPackedLabel;

  /// No description provided for @emptyInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is empty'**
  String get emptyInventoryTitle;

  /// No description provided for @emptyInventorySub.
  ///
  /// In en, this message translates to:
  /// **'Tap + to start adding items'**
  String get emptyInventorySub;

  /// No description provided for @tripTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Trip Title'**
  String get tripTitleHint;

  /// No description provided for @tripDetailsNavTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetailsNavTitle;

  /// No description provided for @clearAllButton.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllButton;

  /// No description provided for @clearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearButton;

  /// No description provided for @noItemsInTrip.
  ///
  /// In en, this message translates to:
  /// **'No items in this trip'**
  String get noItemsInTrip;

  /// No description provided for @addItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItemsTitle;

  /// No description provided for @createNewItem.
  ///
  /// In en, this message translates to:
  /// **'Create New Item'**
  String get createNewItem;

  /// No description provided for @noItemsAvailableToAdd.
  ///
  /// In en, this message translates to:
  /// **'No items available to add'**
  String get noItemsAvailableToAdd;

  /// No description provided for @tripDetailsError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String tripDetailsError(Object error);

  /// No description provided for @itemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemNameLabel;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Toothbrush'**
  String get itemNameHint;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @congratulationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulationsTitle;

  /// No description provided for @congratulationsMessage.
  ///
  /// In en, this message translates to:
  /// **'All items are packed! You are ready to go!'**
  String get congratulationsMessage;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @newTripTitle.
  ///
  /// In en, this message translates to:
  /// **'New Trip'**
  String get newTripTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'nl',
        'pl',
        'pt',
        'uk'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
