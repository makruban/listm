// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'Ласкаво просимо до TripWise';

  @override
  String get packingLists => 'Списки речей';

  @override
  String get allItems => 'Усі предмети';

  @override
  String get addPackingList => 'Додати список';

  @override
  String get addItem => 'Додати предмет';

  @override
  String get noTripsMessage =>
      'Списки речей не знайдено. Натисніть +, щоб додати.';

  @override
  String tripsLoadError(Object error) {
    return 'Не вдалося завантажити списки речей: $error';
  }

  @override
  String get untitledTrip => 'Подорож без назви';

  @override
  String get itemsLabel => 'предметів';

  @override
  String get renameAction => 'Перейменувати';

  @override
  String get infoAction => 'Інфо';

  @override
  String get deleteAction => 'Видалити';

  @override
  String get tripDetailsTitle => 'Деталі подорожі';

  @override
  String tripTitleLabel(Object title) {
    return 'Назва: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get closeButton => 'Закрити';

  @override
  String get removeAction => 'Вилучити';

  @override
  String get onboardingTitle1 => 'Плануйте свої подорожі';

  @override
  String get onboardingDesc1Part1 => 'Створіть подорож, натиснувши кнопку ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'Ніколи не забувайте речі';

  @override
  String get onboardingDesc2 =>
      'Слідкуйте за своїми речами та переконайтеся, що маєте все необхідне.';

  @override
  String get onboardingTitle3 => 'Готові до зльоту';

  @override
  String get onboardingDesc3 =>
      'Насолоджуйтеся подорожжю з упевненістю, що ви повністю готові.';

  @override
  String get skipButton => 'Пропустити';

  @override
  String get nextButton => 'Далі';

  @override
  String get doneButton => 'Готово';

  @override
  String get noTripsMessageTitle => 'Списки речей не знайдено';

  @override
  String get noTripsMessageSub => 'Натисніть +, щоб додати.';

  @override
  String get deleteItemTitle => 'Видалити предмет';

  @override
  String deleteItemConfirmation(Object title) {
    return 'Ви впевнені, що хочете видалити \"$title\"?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'Увага! Цей предмет використовується в подорожі:';

  @override
  String get cancelButton => 'Скасувати';

  @override
  String get deleteButton => 'Видалити';

  @override
  String itemsLoadError(Object error) {
    return 'Помилка: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'Предмет $index';
  }

  @override
  String get itemDetailsTitle => 'Деталі предмета';

  @override
  String itemTitleLabel(Object title) {
    return 'Назва: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get notPackedLabel => 'Не запаковано';

  @override
  String get emptyInventoryTitle => 'Ваш інвентар порожній';

  @override
  String get emptyInventorySub => 'Натисніть +, щоб почати додавати предмети';

  @override
  String get tripTitleHint => 'Назва подорожі';

  @override
  String get tripDetailsNavTitle => 'Деталі подорожі';

  @override
  String get clearAllButton => 'Очистити все';

  @override
  String get clearButton => 'Очистити';

  @override
  String get noItemsInTrip => 'У цій подорожі немає предметів';

  @override
  String get addItemsTitle => 'Додати предмети';

  @override
  String get createNewItem => 'Створити новий предмет';

  @override
  String get noItemsAvailableToAdd => 'Немає предметів для додавання';

  @override
  String tripDetailsError(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get itemNameLabel => 'Назва предмета';

  @override
  String get itemNameHint => 'напр., Зубна щітка';

  @override
  String get createButton => 'Створити';

  @override
  String get congratulationsTitle => 'Вітаємо!';

  @override
  String get congratulationsMessage => 'Всі речі зібрані! Ви готові вирушати!';

  @override
  String get okButton => 'ОК';

  @override
  String get newTripTitle => 'Нова подорож';

  @override
  String get settings => 'Налаштування';

  @override
  String get preferences => 'Уподобання';

  @override
  String get language => 'Мова';

  @override
  String get selectLanguage => 'Вибрати мову';

  @override
  String get themeMode => 'Режим теми';

  @override
  String get selectThemeMode => 'Вибрати режим теми';

  @override
  String get themeSystem => 'За замовчуванням системи';

  @override
  String get themeLight => 'Світлий';

  @override
  String get themeDark => 'Темний';
}
