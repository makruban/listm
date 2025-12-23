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
}
