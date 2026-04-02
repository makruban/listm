// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'مرحبًا بك في TripWise';

  @override
  String get packingLists => 'قوائم التعبئة';

  @override
  String get allItems => 'جميع العناصر';

  @override
  String get addPackingList => 'إضافة قائمة تعبئة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get noTripsMessage =>
      'لم يتم العثور على قوائم تعبئة. اضغط على + لإضافة واحدة.';

  @override
  String tripsLoadError(Object error) {
    return 'فشل تحميل قوائم التعبئة: $error';
  }

  @override
  String get untitledTrip => 'رحلة بدون عنوان';

  @override
  String get itemsLabel => 'عناصر';

  @override
  String get renameAction => 'إعادة تسمية';

  @override
  String get infoAction => 'معلومات';

  @override
  String get deleteAction => 'حذف';

  @override
  String get tripDetailsTitle => 'تفاصيل الرحلة';

  @override
  String tripTitleLabel(Object title) {
    return 'العنوان: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'المعرف: $id';
  }

  @override
  String get closeButton => 'إغلاق';

  @override
  String get removeAction => 'إزالة';

  @override
  String get onboardingTitle1 => 'خطط لرحلاتك';

  @override
  String get onboardingDesc1Part1 => 'أنشئ رحلة بالنقر على زر ';

  @override
  String get onboardingDesc1Part2 => '';

  @override
  String get onboardingTitle2 => 'لا تنسى أي عنصر أبداً';

  @override
  String get onboardingDesc2 =>
      'تتبع عناصرك وتأكد من أن لديك كل ما تحتاجه لرحلتك.';

  @override
  String get onboardingTitle3 => 'جاهز للإقلاع';

  @override
  String get onboardingDesc3 =>
      'استمتع برحلتك مع راحة البال بمعرفة أنك مستعد تمامًا.';

  @override
  String get skipButton => 'تخطي';

  @override
  String get nextButton => 'التالي';

  @override
  String get doneButton => 'تم';

  @override
  String get noTripsMessageTitle => 'لم يتم العثور على قوائم تعبئة';

  @override
  String get noTripsMessageSub => 'اضغط على + لإضافة واحدة.';

  @override
  String get deleteItemTitle => 'حذف العنصر';

  @override
  String deleteItemConfirmation(Object title) {
    return 'هل أنت متأكد أنك تريد حذف \"$title\"؟';
  }

  @override
  String get itemUsedInTripsWarning => 'انتباه! يستخدم هذا العنصر في الرحلات:';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get deleteButton => 'حذف';

  @override
  String itemsLoadError(Object error) {
    return 'خطأ: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'عنصر $index';
  }

  @override
  String get itemDetailsTitle => 'تفاصيل العنصر';

  @override
  String itemTitleLabel(Object title) {
    return 'العنوان: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'المعرف: $id';
  }

  @override
  String get notPackedLabel => 'غير معبأ';

  @override
  String get emptyInventoryTitle => 'المخزون الخاص بك فارغ';

  @override
  String get emptyInventorySub => 'اضغط على + للبدء في إضافة عناصر';

  @override
  String get tripTitleHint => 'عنوان الرحلة';

  @override
  String get tripDetailsNavTitle => 'تفاصيل الرحلة';

  @override
  String get clearAllButton => 'مسح الكل';

  @override
  String get clearButton => 'مسح';

  @override
  String get noItemsInTrip => 'لا توجد عناصر في هذه الرحلة';

  @override
  String get addItemsTitle => 'إضافة عناصر';

  @override
  String get createNewItem => 'إنشاء عنصر جديد';

  @override
  String get noItemsAvailableToAdd => 'لا توجد عناصر متاحة للإضافة';

  @override
  String tripDetailsError(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get itemNameLabel => 'اسم العنصر';

  @override
  String get itemNameHint => 'مثل، فرشاة أسنان';

  @override
  String get createButton => 'إنشاء';

  @override
  String get congratulationsTitle => 'تهانينا!';

  @override
  String get congratulationsMessage => 'جميع العناصر معبأة! أنت جاهز للذهاب!';

  @override
  String get okButton => 'موافق';

  @override
  String get newTripTitle => 'رحلة جديدة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get themeMode => 'وضع الألوان';

  @override
  String get selectThemeMode => 'اختر وضع الألوان';

  @override
  String get themeSystem => 'افتراضي النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';
}
