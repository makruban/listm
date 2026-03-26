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

  @override
  String get onboardingTitle1 => 'Plane deine Reisen';

  @override
  String get onboardingDesc1Part1 =>
      'Erstelle eine Reise, indem du auf die Schaltfläche ';

  @override
  String get onboardingDesc1Part2 => ' klickst';

  @override
  String get onboardingTitle2 => 'Vergiss nie wieder etwas';

  @override
  String get onboardingDesc2 =>
      'Behalte den Überblick über deine Sachen und stelle sicher, dass du alles für deine Reise hast.';

  @override
  String get onboardingTitle3 => 'Bereit zum Abflug';

  @override
  String get onboardingDesc3 =>
      'Genieße deine Reise mit der Gewissheit, dass du bestens vorbereitet bist.';

  @override
  String get skipButton => 'Überspringen';

  @override
  String get nextButton => 'Weiter';

  @override
  String get doneButton => 'Fertig';

  @override
  String get noTripsMessageTitle => 'Keine Packlisten gefunden';

  @override
  String get noTripsMessageSub => 'Tippe auf +, um eine hinzuzufügen.';

  @override
  String get deleteItemTitle => 'Element löschen';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Möchten Sie \"$title\" wirklich löschen?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Achtung! Dieses Element wird in Reise(n) verwendet:';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get deleteButton => 'Löschen';

  @override
  String itemsLoadError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Element $index';
  }

  @override
  String get itemDetailsTitle => 'Elementdetails';

  @override
  String itemTitleLabel(Object title) {
    return 'Titel: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Nicht gepackt';

  @override
  String get emptyInventoryTitle => 'Dein Inventar ist leer';

  @override
  String get emptyInventorySub => 'Tippe auf +, um Elemente hinzuzufügen';

  @override
  String get tripTitleHint => 'Reisetitel';

  @override
  String get tripDetailsNavTitle => 'Reisedetails';

  @override
  String get clearAllButton => 'Alles löschen';

  @override
  String get clearButton => 'Löschen';

  @override
  String get noItemsInTrip => 'Keine Artikel auf dieser Reise';

  @override
  String get addItemsTitle => 'Artikel hinzufügen';

  @override
  String get createNewItem => 'Neuen Artikel erstellen';

  @override
  String get noItemsAvailableToAdd => 'Keine Artikel zum Hinzufügen verfügbar';

  @override
  String tripDetailsError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get itemNameLabel => 'Artikelname';

  @override
  String get itemNameHint => 'z.B. Zahnbürste';

  @override
  String get createButton => 'Erstellen';

  @override
  String get congratulationsTitle => 'Herzlichen Glückwunsch!';

  @override
  String get congratulationsMessage =>
      'Alle Artikel sind gepackt! Sie sind bereit zu gehen!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Neue Reise';

  @override
  String get settings => 'Einstellungen';

  @override
  String get preferences => 'Präferenzen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get themeMode => 'Darstellungsmodus';

  @override
  String get selectThemeMode => 'Darstellungsmodus auswählen';

  @override
  String get themeSystem => 'Systemstandard';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';
}
