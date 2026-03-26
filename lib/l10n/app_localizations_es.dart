// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Bienvenido a TripWise';

  @override
  String get packingLists => 'Listas de empaque';

  @override
  String get allItems => 'Todos los artículos';

  @override
  String get addPackingList => 'Agregar lista de empaque';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get noTripsMessage =>
      'No se encontraron listas de viaje. Toque + para agregar una.';

  @override
  String tripsLoadError(Object error) {
    return 'Error al cargar las listas de viaje: $error';
  }

  @override
  String get untitledTrip => 'Viaje sin título';

  @override
  String get itemsLabel => 'elementos';

  @override
  String get renameAction => 'Renombrar';

  @override
  String get infoAction => 'Info';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get tripDetailsTitle => 'Detalles del viaje';

  @override
  String tripTitleLabel(Object title) {
    return 'Título: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Cerrar';

  @override
  String get removeAction => 'Quitar';

  @override
  String get onboardingTitle1 => 'Planifica tus viajes';

  @override
  String get onboardingDesc1Part1 => 'Crea un viaje haciendo clic en el botón ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'Nunca olvides un artículo';

  @override
  String get onboardingDesc2 =>
      'Lleva un registro de tus artículos y asegúrate de tener todo lo que necesitas.';

  @override
  String get onboardingTitle3 => 'Listo para el despegue';

  @override
  String get onboardingDesc3 =>
      'Disfruta de tu viaje con la tranquilidad de estar preparado.';

  @override
  String get skipButton => 'Omitir';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get doneButton => 'Listo';

  @override
  String get noTripsMessageTitle => 'No se encontraron listas';

  @override
  String get noTripsMessageSub => 'Toca + para agregar una.';

  @override
  String get deleteItemTitle => 'Eliminar artículo';

  @override
  String deleteItemConfirmation(Object title) {
    return '¿Seguro que quieres eliminar \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      '¡Atención! Este artículo se usa en Viaje(s):';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String itemsLoadError(Object error) {
    return 'Error: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Artículo $index';
  }

  @override
  String get itemDetailsTitle => 'Detalles del artículo';

  @override
  String itemTitleLabel(Object title) {
    return 'Título: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'No empacado';

  @override
  String get emptyInventoryTitle => 'Tu inventario está vacío';

  @override
  String get emptyInventorySub => 'Toca + para comenzar a agregar artículos';

  @override
  String get tripTitleHint => 'Título del viaje';

  @override
  String get tripDetailsNavTitle => 'Detalles del viaje';

  @override
  String get clearAllButton => 'Borrar todo';

  @override
  String get clearButton => 'Borrar';

  @override
  String get noItemsInTrip => 'No hay artículos en este viaje';

  @override
  String get addItemsTitle => 'Agregar artículos';

  @override
  String get createNewItem => 'Crear nuevo artículo';

  @override
  String get noItemsAvailableToAdd =>
      'No hay artículos disponibles para agregar';

  @override
  String tripDetailsError(Object error) {
    return 'Error: $error';
  }

  @override
  String get itemNameLabel => 'Nombre del artículo';

  @override
  String get itemNameHint => 'ej. Cepillo de dientes';

  @override
  String get createButton => 'Crear';

  @override
  String get congratulationsTitle => '¡Felicidades!';

  @override
  String get congratulationsMessage =>
      '¡Todos los artículos están empacados! ¡Estás listo para ir!';

  @override
  String get okButton => 'OK';

  @override
  String get newTripTitle => 'Nuevo Viaje';

  @override
  String get settings => 'Ajustes';

  @override
  String get preferences => 'Preferencias';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get selectThemeMode => 'Seleccionar Modo de Tema';

  @override
  String get themeSystem => 'Predeterminado del sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';
}
