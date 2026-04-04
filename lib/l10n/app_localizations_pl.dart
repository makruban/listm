// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Witaj w TripWise';

  @override
  String get packingLists => 'Podróże';

  @override
  String get allItems => 'Wszystkie przedmioty';

  @override
  String get addPackingList => 'Dodaj listę';

  @override
  String get addItem => 'Dodaj przedmiot';

  @override
  String get noTripsMessage => 'Nie znaleziono podróży. Dotknij +, aby dodać.';

  @override
  String tripsLoadError(Object error) {
    return 'Nie udało się wczytać podróży: $error';
  }

  @override
  String get untitledTrip => 'Podróż bez tytułu';

  @override
  String get itemsLabel => 'przedmioty';

  @override
  String get renameAction => 'Zmień nazwę';

  @override
  String get infoAction => 'Informacje';

  @override
  String get deleteAction => 'Usuń';

  @override
  String get tripDetailsTitle => 'Szczegóły podróży';

  @override
  String tripTitleLabel(Object title) {
    return 'Tytuł: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Zamknij';

  @override
  String get removeAction => 'Usuń';

  @override
  String get onboardingTitle1 => 'Zaplanuj swoje podróże';

  @override
  String get onboardingDesc1Part1 => 'Utwórz podróż, klikając przycisk ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'Nigdy nie zapomnij o niczym';

  @override
  String get onboardingDesc2 =>
      'Śledź swoje przedmioty i upewnij się, że masz wszystko, czego potrzebujesz.';

  @override
  String get onboardingTitle3 => 'Gotowy do startu';

  @override
  String get onboardingDesc3 =>
      'Ciesz się podróżą, mając pewność, że jesteś w pełni przygotowany.';

  @override
  String get skipButton => 'Pomiń';

  @override
  String get nextButton => 'Dalej';

  @override
  String get doneButton => 'Gotowe';

  @override
  String get noTripsMessageTitle => 'Nie znaleziono podróży';

  @override
  String get noTripsMessageSub => 'Dotknij +, aby dodać.';

  @override
  String get deleteItemTitle => 'Usuń przedmiot';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Czy na pewno chcesz usunąć \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Uwaga! Ten przedmiot jest używany w podróży:';

  @override
  String get cancelButton => 'Anuluj';

  @override
  String get deleteButton => 'Usuń';

  @override
  String itemsLoadError(Object error) {
    return 'Błąd: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Przedmiot $index';
  }

  @override
  String get itemDetailsTitle => 'Szczegóły przedmiotu';

  @override
  String itemTitleLabel(Object title) {
    return 'Tytuł: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Nie spakowano';

  @override
  String get emptyInventoryTitle => 'Twój ekwipunek jest pusty';

  @override
  String get emptyInventorySub => 'Dotknij +, aby zacząć dodawać przedmioty';

  @override
  String get tripTitleHint => 'Tytuł podróży';

  @override
  String get tripDetailsNavTitle => 'Szczegóły podróży';

  @override
  String get clearAllButton => 'Wyczyść wszystko';

  @override
  String get clearButton => 'Wyczyść';

  @override
  String get noItemsInTrip => 'Brak elementów w tej podróży';

  @override
  String get addItemsTitle => 'Dodaj elementy';

  @override
  String get createNewItem => 'Utwórz nowy element';

  @override
  String get noItemsAvailableToAdd => 'Brak dostępnych elementów do dodania';

  @override
  String tripDetailsError(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get itemNameLabel => 'Nazwa elementu';

  @override
  String get itemNameHint => 'np. Szczoteczka do zębów';

  @override
  String get createButton => 'Utwórz';

  @override
  String get congratulationsTitle => 'Gratulacje!';

  @override
  String get congratulationsMessage =>
      'Wszystkie elementy są spakowane! Jesteś gotowy do drogi!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nowa Podróż';

  @override
  String get settings => 'Ustawienia';

  @override
  String get preferences => 'Preferencje';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz Język';

  @override
  String get themeMode => 'Tryb Motywu';

  @override
  String get selectThemeMode => 'Wybierz Tryb Motywu';

  @override
  String get themeSystem => 'Domyślny systemu';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get itemAlreadyExistsError => 'Element o tej nazwie już istnieje.';

  @override
  String get searchHint => 'Szukaj';
}
