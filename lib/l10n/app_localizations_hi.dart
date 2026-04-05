// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'TripWise';

  @override
  String get welcome => 'TripWise में आपका स्वागत है';

  @override
  String get packingLists => 'यात्राएँ';

  @override
  String get allItems => 'सभी सामान';

  @override
  String get addPackingList => 'सूची जोड़ें';

  @override
  String get addItem => 'सामान जोड़ें';

  @override
  String get noTripsMessage =>
      'कोई यात्रा नहीं मिली। एक जोड़ने के लिए + पर टैप करें।';

  @override
  String tripsLoadError(Object error) {
    return 'यात्राएँ लोड करने में विफल: $error';
  }

  @override
  String get untitledTrip => 'अनाम यात्रा';

  @override
  String get itemsLabel => 'आइटम';

  @override
  String get renameAction => 'नाम बदलें';

  @override
  String get infoAction => 'जानकारी';

  @override
  String get deleteAction => 'हटाएं';

  @override
  String get tripDetailsTitle => 'यात्रा विवरण';

  @override
  String tripTitleLabel(Object title) {
    return 'शीर्षक: $title';
  }

  @override
  String tripIdLabel(Object id) {
    return 'आईडी: $id';
  }

  @override
  String get closeButton => 'बंद करें';

  @override
  String get removeAction => 'निकालें';

  @override
  String get onboardingTitle1 => 'अपनी यात्राओं की योजना बनाएं';

  @override
  String get onboardingDesc1Part1 => 'एक यात्रा बनाने के लिए ';

  @override
  String get onboardingDesc1Part2 => ' बटन पर क्लिक करें';

  @override
  String get onboardingTitle2 => 'कभी कोई सामान न भूलें';

  @override
  String get onboardingDesc2 =>
      'अपने सामान का ध्यान रखें और सुनिश्चित करें कि यात्रा के लिए आपके पास सब कुछ है।';

  @override
  String get onboardingTitle3 => 'उड़ान भरने के लिए तैयार';

  @override
  String get onboardingDesc3 =>
      'यह जानकर पूरे मानसिक शांति के साथ अपनी यात्रा का आनंद लें कि आप पूरी तरह तैयार हैं।';

  @override
  String get skipButton => 'छोड़ें';

  @override
  String get nextButton => 'अगला';

  @override
  String get doneButton => 'हो गया';

  @override
  String get noTripsMessageTitle => 'कोई यात्रा नहीं मिली';

  @override
  String get noTripsMessageSub => 'एक जोड़ने के लिए + पर टैप करें।';

  @override
  String get deleteItemTitle => 'आइटम हटाएं';

  @override
  String deleteItemConfirmation(Object title) {
    return 'क्या आप वाकई \"$title\" हटाना चाहते हैं?';
  }

  @override
  String get itemUsedInTripsWarning =>
      'ध्यान दें! यह आइटम इन यात्राओं में उपयोग किया गया है:';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get deleteButton => 'हटाएं';

  @override
  String itemsLoadError(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String itemCounterLabel(Object index) {
    return 'आइटम $index';
  }

  @override
  String get itemDetailsTitle => 'आइटम विवरण';

  @override
  String itemTitleLabel(Object title) {
    return 'शीर्षक: $title';
  }

  @override
  String itemIdLabel(Object id) {
    return 'आईडी: $id';
  }

  @override
  String get notPackedLabel => 'पैक नहीं किया गया';

  @override
  String get emptyInventoryTitle => 'आपका इन्वेंट्री खाली है';

  @override
  String get emptyInventorySub => 'आइटम जोड़ना शुरू करने के लिए + पर टैप करें';

  @override
  String get tripTitleHint => 'यात्रा का शीर्षक';

  @override
  String get tripDetailsNavTitle => 'यात्रा विवरण';

  @override
  String get clearAllButton => 'सभी साफ़ करें';

  @override
  String get clearButton => 'साफ़ करें';

  @override
  String get noItemsInTrip => 'इस यात्रा में कोई आइटम नहीं है';

  @override
  String get addItemsTitle => 'आइटम जोड़ें';

  @override
  String get createNewItem => 'नया आइटम बनाएं';

  @override
  String get noItemsAvailableToAdd => 'जोड़ने के लिए कोई आइटम उपलब्ध नहीं है';

  @override
  String tripDetailsError(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String get itemNameLabel => 'आइटम का नाम';

  @override
  String get itemNameHint => 'उदाहरण: टूथब्रश';

  @override
  String get createButton => 'बनाएं';

  @override
  String get congratulationsTitle => 'बधाई हो!';

  @override
  String get congratulationsMessage =>
      'सभी आइटम पैक हो गए हैं! आप जाने के लिए तैयार हैं!';

  @override
  String get okButton => 'ठीक है';

  @override
  String get newTripTitle => 'नई यात्रा';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get preferences => 'प्राथमिकताएं';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get themeMode => 'थीम मोड';

  @override
  String get selectThemeMode => 'थीम मोड चुनें';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get itemAlreadyExistsError => 'इस नाम का आइटम पहले से मौजूद है।';

  @override
  String get searchHint => 'खोजें';
}
