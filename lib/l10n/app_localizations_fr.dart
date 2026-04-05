// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Bienvenue sur TripWise';

  @override
  String get packingLists => 'Voyages';

  @override
  String get allItems => 'Tous les articles';

  @override
  String get addPackingList => 'Ajouter une liste';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get noTripsMessage =>
      'Aucun voyage trouvé. Appuyez sur + pour en ajouter un.';

  @override
  String tripsLoadError(Object error) {
    return 'Échec du chargement des voyages : $error';
  }

  @override
  String get untitledTrip => 'Voyage sans titre';

  @override
  String get itemsLabel => 'articles';

  @override
  String get renameAction => 'Renommer';

  @override
  String get infoAction => 'Infos';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get tripDetailsTitle => 'Détails du voyage';

  @override
  String tripTitleLabel(Object title) {
    return 'Titre : $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID : $id';
  }

  @override
  String get closeButton => 'Fermer';

  @override
  String get removeAction => 'Retirer';

  @override
  String get onboardingTitle1 => 'Planifiez vos voyages';

  @override
  String get onboardingDesc1Part1 =>
      'Créez un voyage en cliquant sur le bouton ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'N\'oubliez jamais un article';

  @override
  String get onboardingDesc2 =>
      'Gardez une trace de vos articles et assurez-vous d\'avoir tout ce dont vous avez besoin.';

  @override
  String get onboardingTitle3 => 'Prêt au décollage';

  @override
  String get onboardingDesc3 =>
      'Profitez de votre voyage l\'esprit tranquille.';

  @override
  String get skipButton => 'Passer';

  @override
  String get nextButton => 'Suivant';

  @override
  String get doneButton => 'Terminé';

  @override
  String get noTripsMessageTitle => 'Aucun voyage trouvé';

  @override
  String get noTripsMessageSub => 'Appuyez sur + pour en ajouter une.';

  @override
  String get deleteItemTitle => 'Supprimer l\'article';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Êtes-vous sûr de vouloir supprimer \"$title\" ?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Attention ! Cet article est utilisé dans le(s) voyage(s) :';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String itemsLoadError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Article $index';
  }

  @override
  String get itemDetailsTitle => 'Détails de l\'article';

  @override
  String itemTitleLabel(Object title) {
    return 'Titre : $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID : $id';
  }

  @override
  String get notPackedLabel => 'Non emballé';

  @override
  String get emptyInventoryTitle => 'Votre inventaire est vide';

  @override
  String get emptyInventorySub => 'Appuyez sur + pour ajouter des articles';

  @override
  String get tripTitleHint => 'Titre du voyage';

  @override
  String get tripDetailsNavTitle => 'Détails du voyage';

  @override
  String get clearAllButton => 'Tout effacer';

  @override
  String get clearButton => 'Effacer';

  @override
  String get noItemsInTrip => 'Aucun article dans ce voyage';

  @override
  String get addItemsTitle => 'Ajouter des articles';

  @override
  String get createNewItem => 'Créer un nouvel article';

  @override
  String get noItemsAvailableToAdd => 'Aucun article disponible à ajouter';

  @override
  String tripDetailsError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get itemNameLabel => 'Nom de l\'article';

  @override
  String get itemNameHint => 'ex. Brosse à dents';

  @override
  String get createButton => 'Créer';

  @override
  String get congratulationsTitle => 'Félicitations !';

  @override
  String get congratulationsMessage =>
      'Tous les articles sont emballés ! Vous êtes prêt à partir !';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nouveau Voyage';

  @override
  String get settings => 'Paramètres';

  @override
  String get preferences => 'Préférences';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get themeMode => 'Mode de Thème';

  @override
  String get selectThemeMode => 'Sélectionner le Mode de Thème';

  @override
  String get themeSystem => 'Par défaut du système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get itemAlreadyExistsError => 'Un élément portant ce nom existe déjà.';

  @override
  String get searchHint => 'Rechercher';
}
