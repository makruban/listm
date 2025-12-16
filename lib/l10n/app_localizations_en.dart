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
  String get packingLists => 'Packing Lists';

  @override
  String get allItems => 'All Items';

  @override
  String get addPackingList => 'Add Packing List';

  @override
  String get addItem => 'Add Item';

  @override
  String get noTripsMessage => 'No packing lists found. Tap + to add one.';

  @override
  String tripsLoadError(Object error) {
    return 'Failed to load packing lists: $error';
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
}
