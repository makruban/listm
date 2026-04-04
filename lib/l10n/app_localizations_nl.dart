// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Welkom bij TripWise';

  @override
  String get packingLists => 'Reizen';

  @override
  String get allItems => 'Alle items';

  @override
  String get addPackingList => 'Lijst toevoegen';

  @override
  String get addItem => 'Item toevoegen';

  @override
  String get noTripsMessage =>
      'Geen reizen gevonden. Tik op + om er een toe te voegen.';

  @override
  String tripsLoadError(Object error) {
    return 'Kan reizen niet laden: $error';
  }

  @override
  String get untitledTrip => 'Naamloze reis';

  @override
  String get itemsLabel => 'items';

  @override
  String get renameAction => 'Hernoemen';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Verwijderen';

  @override
  String get tripDetailsTitle => 'Reisgegevens';

  @override
  String tripTitleLabel(Object title) {
    return 'Titel: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Sluiten';

  @override
  String get removeAction => 'Verwijderen';

  @override
  String get onboardingTitle1 => 'Plan je reizen';

  @override
  String get onboardingDesc1Part1 => 'Maak een reis aan door op de ';

  @override
  String get onboardingDesc1Part2 => ' knop te klikken';

  @override
  String get onboardingTitle2 => 'Vergeet nooit meer een item';

  @override
  String get onboardingDesc2 =>
      'Houd al je items bij en zorg dat je alles hebt voor je reis.';

  @override
  String get onboardingTitle3 => 'Klaar voor vertrek';

  @override
  String get onboardingDesc3 =>
      'Geniet van je reis met de gemoedsrust dat je goed voorbereid bent.';

  @override
  String get skipButton => 'Overslaan';

  @override
  String get nextButton => 'Volgende';

  @override
  String get doneButton => 'Klaar';

  @override
  String get noTripsMessageTitle => 'Geen reizen gevonden';

  @override
  String get noTripsMessageSub => 'Tik op + om er een toe te voegen.';

  @override
  String get deleteItemTitle => 'Item verwijderen';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Weet u zeker dat u \"$title\" wilt verwijderen?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Let op! Dit item wordt gebruikt in Reis(reizen):';

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get deleteButton => 'Verwijderen';

  @override
  String itemsLoadError(Object error) {
    return 'Fout: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Item $index';
  }

  @override
  String get itemDetailsTitle => 'Itemdetails';

  @override
  String itemTitleLabel(Object title) {
    return 'Titel: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Niet ingepakt';

  @override
  String get emptyInventoryTitle => 'Je inventaris is leeg';

  @override
  String get emptyInventorySub => 'Tik op + om items toe te voegen';

  @override
  String get tripTitleHint => 'Reistitel';

  @override
  String get tripDetailsNavTitle => 'Reisdetails';

  @override
  String get clearAllButton => 'Alles wissen';

  @override
  String get clearButton => 'Wissen';

  @override
  String get noItemsInTrip => 'Geen artikelen in deze reis';

  @override
  String get addItemsTitle => 'Artikelen toevoegen';

  @override
  String get createNewItem => 'Nieuw artikel maken';

  @override
  String get noItemsAvailableToAdd =>
      'Geen artikelen beschikbaar om toe te voegen';

  @override
  String tripDetailsError(Object error) {
    return 'Fout: $error';
  }

  @override
  String get itemNameLabel => 'Artikelnaam';

  @override
  String get itemNameHint => 'bijv. Tandenborstel';

  @override
  String get createButton => 'Maken';

  @override
  String get congratulationsTitle => 'Gefeliciteerd!';

  @override
  String get congratulationsMessage =>
      'Alle items zijn ingepakt! Je bent klaar om te gaan!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nieuwe Reis';

  @override
  String get settings => 'Instellingen';

  @override
  String get preferences => 'Voorkeuren';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Selecteer Taal';

  @override
  String get themeMode => 'Theamamodus';

  @override
  String get selectThemeMode => 'Selecteer Theamamodus';

  @override
  String get themeSystem => 'Systeemstandaard';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get itemAlreadyExistsError => 'Er bestaat al een item met deze naam.';

  @override
  String get searchHint => 'Zoeken';
}
