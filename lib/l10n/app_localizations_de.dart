// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Willkommen bei TripWise';

  @override
  String get packingLists => 'Packlisten';

  @override
  String get allItems => 'Alle Artikel';

  @override
  String get addPackingList => 'Packliste hinzufügen';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get noTripsMessage =>
      'Keine Packlisten gefunden. Tippe auf +, um eine hinzuzufügen.';

  @override
  String tripsLoadError(Object error) {
    return 'Fehler beim Laden der Packlisten: $error';
  }

  @override
  String get untitledTrip => 'Unbenannte Reise';

  @override
  String get itemsLabel => 'Elemente';

  @override
  String get renameAction => 'Umbenennen';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get tripDetailsTitle => 'Reisedetails';

  @override
  String tripTitleLabel(Object title) {
    return 'Titel: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Schließen';

  @override
  String get removeAction => 'Entfernen';
}
