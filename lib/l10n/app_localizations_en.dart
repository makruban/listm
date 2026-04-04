// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Welcome to TripWise';

  @override
  String get packingLists => 'Trips';

  @override
  String get allItems => 'All Items';

  @override
  String get addPackingList => 'Add Packing List';

  @override
  String get addItem => 'Add Item';

  @override
  String get noTripsMessage => 'No trips found. Tap + to add one.';

  @override
  String tripsLoadError(Object error) {
    return 'Failed to load trips: $error';
  }

  @override
  String get untitledTrip => 'Untitled trip';

  @override
  String get itemsLabel => 'items';

  @override
  String get renameAction => 'Rename';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Delete';

  @override
  String get tripDetailsTitle => 'Trip Details';

  @override
  String tripTitleLabel(Object title) {
    return 'Title: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Close';

  @override
  String get removeAction => 'Remove';

  @override
  String get onboardingTitle1 => 'Plan your trips';

  @override
  String get onboardingDesc1Part1 => 'Create a trip by clicking the ';

  @override
  String get onboardingDesc1Part2 => ' button';

  @override
  String get onboardingTitle2 => 'Never forget an item';

  @override
  String get onboardingDesc2 =>
      'Keep track of your items and ensure you have everything you need for your journey.';

  @override
  String get onboardingTitle3 => 'Ready for takeoff';

  @override
  String get onboardingDesc3 =>
      'Enjoy your trip with peace of mind knowing you are fully prepared.';

  @override
  String get skipButton => 'Skip';

  @override
  String get nextButton => 'Next';

  @override
  String get doneButton => 'Done';

  @override
  String get noTripsMessageTitle => 'No trips found';

  @override
  String get noTripsMessageSub => 'Tap + to add one.';

  @override
  String get deleteItemTitle => 'Delete Item';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Attention! This item is used in Trip(s):';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String itemsLoadError(Object error) {
    return 'Error: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Item $index';
  }

  @override
  String get itemDetailsTitle => 'Item Details';

  @override
  String itemTitleLabel(Object title) {
    return 'Title: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Not packed';

  @override
  String get emptyInventoryTitle => 'Your inventory is empty';

  @override
  String get emptyInventorySub => 'Tap + to start adding items';

  @override
  String get tripTitleHint => 'Trip Title';

  @override
  String get tripDetailsNavTitle => 'Trip Details';

  @override
  String get clearAllButton => 'Clear all';

  @override
  String get clearButton => 'Clear';

  @override
  String get noItemsInTrip => 'No items in this trip';

  @override
  String get addItemsTitle => 'Add Items';

  @override
  String get createNewItem => 'Create New Item';

  @override
  String get noItemsAvailableToAdd => 'No items available to add';

  @override
  String tripDetailsError(Object error) {
    return 'Error: $error';
  }

  @override
  String get itemNameLabel => 'Item Name';

  @override
  String get itemNameHint => 'e.g., Toothbrush';

  @override
  String get createButton => 'Create';

  @override
  String get congratulationsTitle => 'Congratulations!';

  @override
  String get congratulationsMessage =>
      'All items are packed! You are ready to go!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'New Trip';

  @override
  String get settings => 'Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get selectThemeMode => 'Select Theme Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get itemAlreadyExistsError => 'Item with this name already exists.';

  @override
  String get searchHint => 'Search';
}
