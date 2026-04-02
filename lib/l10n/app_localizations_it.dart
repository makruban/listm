// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Benvenuto su TripWise';

  @override
  String get packingLists => 'Liste bagagli';

  @override
  String get allItems => 'Tutti gli elementi';

  @override
  String get addPackingList => 'Aggiungi lista';

  @override
  String get addItem => 'Aggiungi elemento';

  @override
  String get noTripsMessage =>
      'Nessuna lista trovata. Tocca + per aggiungerne una.';

  @override
  String tripsLoadError(Object error) {
    return 'Impossibile caricare le liste: $error';
  }

  @override
  String get untitledTrip => 'Viaggio senza titolo';

  @override
  String get itemsLabel => 'elementi';

  @override
  String get renameAction => 'Rinomina';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Elimina';

  @override
  String get tripDetailsTitle => 'Dettagli viaggio';

  @override
  String tripTitleLabel(Object title) {
    return 'Titolo: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Chiudi';

  @override
  String get removeAction => 'Rimuovi';

  @override
  String get onboardingTitle1 => 'Pianifica i tuoi viaggi';

  @override
  String get onboardingDesc1Part1 => 'Crea un viaggio cliccando sul pulsante ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'Non dimenticare mai nulla';

  @override
  String get onboardingDesc2 =>
      'Tieni traccia dei tuoi articoli e assicurati di avere tutto il necessario.';

  @override
  String get onboardingTitle3 => 'Pronto al decollo';

  @override
  String get onboardingDesc3 =>
      'Goditi il tuo viaggio con la tranquillità di essere preparato.';

  @override
  String get skipButton => 'Salta';

  @override
  String get nextButton => 'Avanti';

  @override
  String get doneButton => 'Fine';

  @override
  String get noTripsMessageTitle => 'Nessuna lista trovata';

  @override
  String get noTripsMessageSub => 'Tocca + per aggiungerne una.';

  @override
  String get deleteItemTitle => 'Elimina elemento';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Sei sicuro di voler eliminare \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Attenzione! Questo elemento è usato in Viaggio/i:';

  @override
  String get cancelButton => 'Annulla';

  @override
  String get deleteButton => 'Elimina';

  @override
  String itemsLoadError(Object error) {
    return 'Errore: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Elemento $index';
  }

  @override
  String get itemDetailsTitle => 'Dettagli elemento';

  @override
  String itemTitleLabel(Object title) {
    return 'Titolo: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Non confezionato';

  @override
  String get emptyInventoryTitle => 'Il tuo inventario è vuoto';

  @override
  String get emptyInventorySub => 'Tocca + per iniziare ad aggiungere elementi';

  @override
  String get tripTitleHint => 'Titolo del viaggio';

  @override
  String get tripDetailsNavTitle => 'Dettagli del viaggio';

  @override
  String get clearAllButton => 'Cancella tutto';

  @override
  String get clearButton => 'Cancella';

  @override
  String get noItemsInTrip => 'Nessun articolo in questo viaggio';

  @override
  String get addItemsTitle => 'Aggiungi articoli';

  @override
  String get createNewItem => 'Crea nuovo articolo';

  @override
  String get noItemsAvailableToAdd =>
      'Nessun articolo disponibile da aggiungere';

  @override
  String tripDetailsError(Object error) {
    return 'Errore: $error';
  }

  @override
  String get itemNameLabel => 'Nome articolo';

  @override
  String get itemNameHint => 'es. Spazzolino da denti';

  @override
  String get createButton => 'Crea';

  @override
  String get congratulationsTitle => 'Congratulazioni!';

  @override
  String get congratulationsMessage =>
      'Tutti gli articoli sono imballati! Sei pronto a partire!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nuovo Viaggio';

  @override
  String get settings => 'Impostazioni';

  @override
  String get preferences => 'Preferenze';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona la Lingua';

  @override
  String get themeMode => 'Modalità Tema';

  @override
  String get selectThemeMode => 'Seleziona la Modalità Tema';

  @override
  String get themeSystem => 'Predefinito di sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';
}
